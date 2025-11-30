struct SettingAPI {
    let endpoint: String
    let host: String
    let scheme: String
    let httpMetods: HttpMetods
}

enum HttpMetods: String {
    case get = "GET"
}
