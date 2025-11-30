import UIKit
import Combine

@MainActor
final class NewsDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let detailView: NewsDetailViewProtocol & UIView
    private let model: NewsDetailViewModelProtocol
    
    private var bag = Set<AnyCancellable>()

    // MARK: - Init
    
    init(model: NewsDetailViewModelProtocol) {
        self.model = model
        self.detailView = NewsDetailView()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("NewsDetailViewController - deinited")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - SetupView

extension NewsDetailViewController: SetupView {
    func setupView() {
        setupSubView()
        setupConstraints()
        setupBindingsModel()
        setupBindingsContentView()
    }
    
    func setupSubView() {
        view.addSubview(detailView)
    }
    
    func setupConstraints() {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        fillToParent(detailView)
    }
}

// MARK: - Private Methods

private extension NewsDetailViewController {
    func setupBindingsModel() {
        model.newSubject
            .sink { [weak self] new in 
                guard let self else { return }
                detailView.configure(new, imageLoader: model.imageService)
            }
            .store(in: &bag)
    }
    
    func setupBindingsContentView() {
        detailView.openSafariPublisher
            .sink { [weak self] tap in
                self?.model.openInSafari()
            }
            .store(in: &bag)
    }
    
    func newsDetailViewDidTapOpenSafari() {
        model.openInSafari()
    }
}
