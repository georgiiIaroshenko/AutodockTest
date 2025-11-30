import Foundation

final class ImageFileExchange: _PrefixedFileExchangeInternals, PrefixedFileExchangeProtocol {
    let exchange: RootFileExchangeProtocol
    let basePath = ["Image"]
    
    init(exchange: RootFileExchangeProtocol) {
        self.exchange = exchange
    }
}
