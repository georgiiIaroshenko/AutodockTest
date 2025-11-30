protocol ContentResettable: AnyObject {
    func resetContent()
}

protocol SetupView: AnyObject {
    func setupView()
    func setupSubView()
    func setupConstraints()
}
