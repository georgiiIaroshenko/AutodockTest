import Foundation

protocol NewsRoutingProtocol: AnyObject {
    func showDetail(_ new: New)
}

protocol NewsDetailRoutingProtocol: AnyObject {
    func showSafari(_ url: URL)
}
