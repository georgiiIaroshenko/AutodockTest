import UIKit

func fillToParent(_ pearent: UIView, _ child: UIView) {
    NSLayoutConstraint.activate([
        child.topAnchor.constraint(equalTo: pearent.topAnchor),
        child.rightAnchor.constraint(equalTo: pearent.rightAnchor),
        child.bottomAnchor.constraint(equalTo: pearent.bottomAnchor),
        child.leftAnchor.constraint(equalTo: pearent.leftAnchor)
    ])
}

func fillToParent(_ child: UIView) {
    guard let parent = child.superview else {
        assertionFailure("fillToPearent(_:) called before child has a superview")
        return
    }
    fillToParent(parent, child)
}

func fillToParentSafeAreaLayoutGuide(_ parent: UIView, _ child: UIView) {
    NSLayoutConstraint.activate([
        child.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor),
        child.rightAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.rightAnchor),
        child.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor),
        child.leftAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leftAnchor)
    ])
}
