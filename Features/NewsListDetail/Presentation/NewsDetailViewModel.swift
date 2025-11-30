import Combine
import Foundation

protocol NewsDetailViewModelProtocol: AnyObject {
    var newSubject: AnyPublisher<New, Never> { get }
    var imageService: SingleImageLoadingProtocol { get }
    func openInSafari()
}

final class NewsDetailViewModel: NewsDetailViewModelProtocol {
    
    // MARK: - Properties
    
    let imageService: SingleImageLoadingProtocol
    private let router: NewsDetailRoutingProtocol
    private let new: CurrentValueSubject<New, Never>
    
    var newSubject: AnyPublisher<New, Never> {
        new.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    
    init(_ new: New, imageService: SingleImageLoadingProtocol, router: NewsDetailRoutingProtocol) {
        self.new = CurrentValueSubject(new)
        self.imageService = imageService
        self.router = router
    }
    
    // MARK: - Public Methods
    
    func openInSafari() {
        guard let url = URL(string: new.value.fullUrl) else { 
            print("❌ [NewsDetailViewModel] Invalid URL: \(new.value.fullUrl)")
            return 
        }
        router.showSafari(url)
    }
}
