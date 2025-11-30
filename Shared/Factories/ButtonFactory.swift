import UIKit

struct ButtonConfig {
    var contentMode: UIView.ContentMode
    var clipsToBounds: Bool
    var cornerRadius: CGFloat?
    var backgroundColor: UIColor?
    var tintColor: UIColor?

    init(contentMode: UIView.ContentMode = .scaleAspectFill,
         clipsToBounds: Bool = true,
         cornerRadius: CGFloat? = nil,
         backgroundColor: UIColor? = nil,
         tintColor: UIColor? = nil) {
        self.contentMode = contentMode
        self.clipsToBounds = clipsToBounds
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
    }
}

final class ButtonFactory {
    @discardableResult
    func make(_ config: ButtonConfig = .init()) -> UIButton {
        let button = UIButton()
        button.contentMode = config.contentMode
        button.clipsToBounds = config.clipsToBounds
        if let radius = config.cornerRadius {
            button.layer.cornerRadius = radius
        }
        if let bg = config.backgroundColor {
            button.backgroundColor = bg
        }
        if let tint = config.tintColor {
            button.tintColor = tint
        }
        return button
    }
}

