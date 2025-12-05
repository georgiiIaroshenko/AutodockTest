import UIKit
protocol SingleImageLoadingProtocol: AnyObject {
    func getImage(from url: String?, imageSize: CGSize) async throws -> UIImage
    func cancelLoadImage(for url: String, imageSize: CGSize)
}
protocol AllImageLoadingProtocol: AnyObject, SingleImageLoadingProtocol {
    func cancelLoadImages()
}

protocol ImageServiceProtocol: SingleImageLoadingProtocol, AllImageLoadingProtocol {}

actor ImageService<Cache: CacheProtocol>: ImageServiceProtocol where Cache.Value == CachedImage {
    private let fileManager: PrefixedFileExchangeProtocol
    private let cache: Cache
    private let downsampler: ImageDownsamplerProtocol
    private let loader: ImageLoaderProtocol
    
    private let inflight = InflightTable<ImageCacheKey, UIImage>()
    
    init(fileManager: PrefixedFileExchangeProtocol, nsCache: Cache, downsampler: ImageDownsamplerProtocol, loader: ImageLoaderProtocol) {
        self.fileManager = fileManager
        self.cache = nsCache
        self.downsampler = downsampler
        self.loader = loader
    }
    
    func getImage(from url: String?, imageSize: CGSize) async throws -> UIImage {
        guard let url = url else { throw CancellationError() }

        let key = ImageCacheKey(url: url, size: imageSize)
        if let cached = cache.get(key) {
            return cached.image
        }
        try Task.checkCancellation()
        
        return try await inflight.run(key: key) { [self] in
            try await loadAndCache(url: url, key: key, size: imageSize)
        }
    }

    nonisolated func cancelLoadImages() {
        Task { [weak self] in
            guard let self else { return }
            await self.inflight.cancelAll()
        }
    }
    
    nonisolated func cancelLoadImage(for url: String, imageSize: CGSize) {
        let key = ImageCacheKey(url: url, size: imageSize)
        Task { [weak self] in
            guard let self else { return }
            await self.inflight.cancel(for: key)
        }
    }
}

private extension ImageService {
    func decodeDetached(_ data: Data) async -> UIImage? {
        return await Task.detached(priority: .userInitiated) {
            guard let image = UIImage(data: data) else { return nil }
            return await image.byPreparingForDisplay()
        }.value
    }
    
    func encodeDetached(_ image: UIImage) async throws -> Data {
        return try await Task.detached(priority: .userInitiated) {
        guard let data = image.jpegData(compressionQuality: 0.7) else { throw ImageServiceError.encodeFailed }
            return data
        }.value
    }
    
    private func loadAndCache(url: String, key: ImageCacheKey, size: CGSize) async throws -> UIImage {
            
            if let data = await fileManager.read(filename: key.key),
               let image = await decodeDetached(data) {
                cache.set(CachedImage(image), for: key)
                return image
            }
            
            guard let validURL = URL(string: url) else {
                throw ImageServiceError.invalidURL
            }
            
            let data = try await loader.loadData(from: validURL)
            
        guard let image = await downsampler.downsampleDetached(data, to: size) else {
                throw ImageServiceError.downsampleFailed
            }
            
            Task.detached(priority: .background) { [fileManager, key] in
                try? await fileManager.write(image.jpegData(compressionQuality: 0.7) ?? Data(), filename: key.key)
            }
            
            cache.set(CachedImage(image), for: key)
            return image
        }
}

// MARK: - ImageServiceError

enum ImageServiceError: Error, LocalizedError {
    case invalidURL
    case decodeFailed
    case encodeFailed
    case downsampleFailed
    case cancelled
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Provided URL string is invalid or malformed."
        case .decodeFailed:
            return "Failed to decode image data."
        case .encodeFailed:
            return "Failed to encode image to JPEG format."
        case .downsampleFailed:
            return "Failed to downsample image to requested size."
        case .cancelled:
            return "Image loading was cancelled."
        }
    }
    
    var failureReason: String? {
        switch self {
        case .invalidURL:
            return "The URL string cannot be converted to a valid URL."
        case .decodeFailed:
            return "The image data is corrupted or in an unsupported format."
        case .encodeFailed:
            return "Unable to compress image to JPEG format."
        case .downsampleFailed:
            return "Image downsampling operation failed."
        case .cancelled:
            return "The image loading task was cancelled before completion."
        }
    }
}
