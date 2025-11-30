import UIKit

final class LoadingFooterView: UICollectionReusableView {
    
    static let elementKind = "LoadingFooterViewKind"
    static let reuseIdentifier = "LoadingFooterView"
    private let animationView = LoadingAnimationView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        isHidden = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            animationView.startAnimation()
            isHidden = false
        } else {
            isHidden = true
            animationView.stopAnimation()
        }
    }
}

extension LoadingFooterView: SetupView {
    func setupView() {
        setupSubView()
        setupConstraints()
    }
    
    func setupSubView() {
        addSubview(animationView)
    }
    
    func setupConstraints() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        fillToParent(self, animationView)
    }
}
