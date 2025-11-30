import UIKit
import Lottie

protocol LoadingAnimationViewProtocol: AnyObject {
    func startAnimation()
    func stopAnimation()
}

final class LoadingAnimationView: UIView, LoadingAnimationViewProtocol {
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    private let animationView = LottieAnimationView(name: "Car")

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        isHidden = false
        animationView.play()
    }
    
    func stopAnimation() {
        animationView.stop()
        isHidden = true
    }
}

extension LoadingAnimationView: SetupView {
    func setupView() {
        setupSubView()
        setupConstraints()
    }
    
    func setupSubView() {
        addSubview(blurView)
        blurView.contentView.addSubview(animationView)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.backgroundBehavior = .pauseAndRestore
    }
    
    func setupConstraints() {
        [blurView, animationView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        fillToParent(blurView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: blurView.widthAnchor, multiplier: 0.25),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)
        ])
    }
}
