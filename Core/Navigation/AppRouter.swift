import UIKit
import SafariServices

// MARK: - AppRouterProtocol

protocol AppRouterProtocol: AnyObject {
    func setRoot(_ viewController: UIViewController, hideBar: Bool)
    func push(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func openURL(_ url: URL)
}

// MARK: - AppRouter

final class AppRouter: AppRouterProtocol {
    
    // MARK: - Properties
    
    private let nav: UINavigationController
    
    // MARK: - Init
    
    init(nav: UINavigationController) { 
        self.nav = nav 
    }

    // MARK: - Navigation Methods
    
    func setRoot(_ vc: UIViewController, hideBar: Bool = false) {
        nav.setViewControllers([vc], animated: false)
        nav.isNavigationBarHidden = hideBar
    }

    func push(_ vc: UIViewController, animated: Bool = true) { 
        nav.pushViewController(vc, animated: animated) 
    }
    
    func present(_ vc: UIViewController, animated: Bool = true) { 
        nav.present(vc, animated: animated) 
    }
    
    func pop(animated: Bool = true) { 
        nav.popViewController(animated: animated) 
    }
    
    func openURL(_ url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemBlue
        safariVC.preferredBarTintColor = .systemBackground
        
        var topController: UIViewController = nav
        while let presented = topController.presentedViewController {
            topController = presented
        }
        
        topController.present(safariVC, animated: true)
    }
}
