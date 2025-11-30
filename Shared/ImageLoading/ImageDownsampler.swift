import UIKit
protocol ImageDownsamplerProtocol: AnyObject {
    func downsample(_ data: Data, to size: CGSize) async -> UIImage?
}

actor ImageDownsampler: ImageDownsamplerProtocol {
    
    private let scale: CGFloat
    
    init(scale: CGFloat = 1.0) {
        self.scale = scale
    }
    
    func downsample(_ data: Data, to size: CGSize) async -> UIImage? {
        let maxSide = max(size.width, size.height)
        let maxDimensionPx = max(Int(maxSide * scale), 1)
        
        let opts: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: false,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionPx,
            kCGImageSourceShouldCache: false
        ]
        
        guard
            let src = CGImageSourceCreateWithData(data as CFData, nil),
            let thumb = CGImageSourceCreateThumbnailAtIndex(src, 0, opts as CFDictionary)
        else {
            return nil
        }
        
        let img = UIImage(cgImage: thumb, scale: scale, orientation: .up)
        return img
    }
}
