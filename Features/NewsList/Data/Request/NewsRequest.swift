import Foundation

struct NewsDTORequest: ApiRequestProtocol {
    
    typealias Response = NewsDTO

    private let pageSize: Int
    private let page: Int

    let settingAPI = SettingAPI(
        endpoint: "/api/news",
        host: "webapi.autodoc.ru",
        scheme: "https",
        httpMetods: .get
    )

    var path: String { "\(page)/\(pageSize)" }

    init(page: Int, pageSize: Int) {
        self.page = page
        self.pageSize = pageSize
    }
}
