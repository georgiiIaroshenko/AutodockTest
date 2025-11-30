import UIKit

extension UIView {
    func imageSizeForFullWidth(aspectRatio: CGFloat = 9.0 / 16.0) -> CGSize {
        let width = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width
        let height = width * aspectRatio
        return CGSize(width: width, height: height)
    }
}
