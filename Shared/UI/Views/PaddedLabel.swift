import UIKit

final class PaddedLabel: UILabel {
    var textInsets: UIEdgeInsets = .zero { didSet { invalidateIntrinsicContentSize(); setNeedsDisplay() } }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetBounds = bounds.inset(by: textInsets)
        var rect = super.textRect(forBounds: insetBounds, limitedToNumberOfLines: numberOfLines)
        rect.origin.x -= textInsets.left
        rect.origin.y -= textInsets.top
        rect.size.width += (textInsets.left + textInsets.right)
        rect.size.height += (textInsets.top + textInsets.bottom)
        return rect
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
