import UIKit

final class FPSMonitor: UIView {

    private let label = UILabel()
    private var displayLink: CADisplayLink?
    private var lastTimestamp: CFTimeInterval = 0
    private var frameCount: Int = 0

    static let shared = FPSMonitor()

    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        start()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        guard displayLink == nil else { return }

        let link = CADisplayLink(target: self, selector: #selector(tick(link:)))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    func stop() {
        displayLink?.invalidate()
        displayLink = nil
        lastTimestamp = 0
        frameCount = 0
        label.text = nil
    }
}

private extension FPSMonitor {
    private func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        layer.cornerRadius = 8
        clipsToBounds = true

        label.font = .monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            widthAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }
    
    @objc private func tick(link: CADisplayLink) {
        if lastTimestamp == 0 {
            lastTimestamp = link.timestamp
            return
        }

        frameCount += 1
        let delta = link.timestamp - lastTimestamp

        if delta >= 0.5 {
            let fps = Double(frameCount) / delta
            lastTimestamp = link.timestamp
            frameCount = 0
            updateLabel(fps: fps)
        }
    }
    
    private func updateLabel(fps: Double) {
        let fpsInt = Int(round(fps))
        label.text = "\(fpsInt) FPS"

        let color: UIColor
        switch fps {
        case 55...:
            color = .systemGreen
        case 40..<55:
            color = .systemOrange
        default:
            color = .systemRed
        }
        label.textColor = color
    }
}
