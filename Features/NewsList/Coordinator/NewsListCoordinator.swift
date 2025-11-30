import Foundation

// MARK: - NewsListCoordinator

final class NewsListCoordinator: Coordinator, NewsRoutingProtocol, NewsDetailRoutingProtocol {
    
    // MARK: - Properties
    
    private let router: AppRouterProtocol
    private let factory: AppFactoryProtocol
    
    // MARK: - Init
    
    init(router: AppRouterProtocol, factory: AppFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    // MARK: - Coordinator
    
    func start() {
        let module = factory.makeNewsList(router: self)
        router.setRoot(module, hideBar: false)
    }
    
    // MARK: - NewsRoutingProtocol
    
    func showDetail(_ new: New) {
        let module = factory.makeNewsDetail(new, router: self)
        router.present(module, animated: true)
    }
    
    // MARK: - NewsDetailRoutingProtocol
    
    func showSafari(_ url: URL) {
        router.openURL(url)
    }
}
