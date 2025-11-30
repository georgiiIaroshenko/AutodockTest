import UIKit

@MainActor
final class LoadableImageView: UIView {
    
    // MARK: - UI Components
    
    private let animationView = LoadingAnimationView()
    private let imageView = UIImageView()
    private let errorImage = UIImage(systemName: "exclamationmark.triangle")
    
    // MARK: - Properties
    
    private var currentURL: String?
    private var currentImageSize: CGSize?
    private weak var loader: SingleImageLoadingProtocol?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        resetContent()
        setupView()
        animationView.startAnimation()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(
        _ imageUrl: String?,
        loader: SingleImageLoadingProtocol,
        imageSize: CGSize
    ) {
        guard currentURL != imageUrl || currentImageSize != imageSize else {
            return
        }
        
        if let url = currentURL, let size = currentImageSize {
            loader.cancelLoadImage(for: url, imageSize: size)
        }
        
        animationView.startAnimation()
        imageView.image = nil
        
        self.loader = loader
        self.currentURL = imageUrl
        self.currentImageSize = imageSize
       
        loadImage(imageUrl, loader: loader, imageSize: imageSize)
    }
    
    private func loadImage(_ imageUrl: String?, loader: SingleImageLoadingProtocol, imageSize: CGSize) {
        Task { [weak self] in
            guard let self else { return }
            guard self.currentURL == imageUrl else {
                return
            }
            do {
                let image = try await loader.getImage(
                    from: imageUrl,
                    imageSize: imageSize
                )
                self.imageView.image = image
                self.animationView.stopAnimation()
            } catch is CancellationError {
                self.animationView.stopAnimation()
                return
            } catch {
                self.imageView.image = self.errorImage
            }
        }
    }
    
    func resetContent() {
        if let url = currentURL,
           let imageSize = currentImageSize,
           let loader
        {
            loader.cancelLoadImage(for: url, imageSize: imageSize)
        }
        currentURL = nil
        currentImageSize = nil
        imageView.image = nil
    }
}

// MARK: - SetupView

extension LoadableImageView: SetupView {
    func setupView() {
        setupSubView()
        setupConstraints()
    }
    
    func setupSubView() {
        addSubview(imageView)
        addSubview(animationView)
        imageView.contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    func setupConstraints() {
        [imageView, animationView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9.0/16.0),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
