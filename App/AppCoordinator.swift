import Foundation

// MARK: - AppCoordinator

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    private let router: AppRouterProtocol
    private let factory: AppFactoryProtocol
    private var childCoordinators: [Coordinator] = []

    // MARK: - Init
    
    init(router: AppRouterProtocol, factory: AppFactoryProtocol) {
        self.router = router
        self.factory = factory
    }
    
    // MARK: - Coordinator
    
    func start() {
        showNewsFlow()
    }
    
    // MARK: - Private
    
    private func showNewsFlow() {
        let newsCoordinator = NewsListCoordinator(router: router, factory: factory)
        childCoordinators.append(newsCoordinator)
        newsCoordinator.start()
    }
}
