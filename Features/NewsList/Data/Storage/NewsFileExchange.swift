import Foundation

final class NewsFileExchange: _PrefixedFileExchangeInternals, PrefixedFileExchangeProtocol {
    let exchange: RootFileExchangeProtocol
    let basePath = ["News"]
    
    init(exchange: RootFileExchangeProtocol) {
        self.exchange = exchange
    }
}

