// Source: https://stackoverflow.com/a/53123144

import Foundation
import Cocoa

class StatusBarIconAnimationUtils: NSObject {
    private var currentFrame = 0
    private var animTimer : Timer
    private var statusBarItem: NSStatusItem!
    private var imageNamePattern: String!
    private var imageCount : Int!

    init(statusBarItem: NSStatusItem!, imageNamePattern: String, imageCount: Int) {
        self.animTimer = Timer.init()
        self.statusBarItem = statusBarItem
        self.imageNamePattern = imageNamePattern
        self.imageCount = imageCount
        super.init()
    }

    func startAnimating() {
        stopAnimating()
        currentFrame = 0
        animTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.updateImage(_:)), userInfo: nil, repeats: true)
    }

    func stopAnimating() {
        animTimer.invalidate()
        setImage(frameCount: 0)
    }

    @objc private func updateImage(_ timer: Timer?) {
        setImage(frameCount: currentFrame)
        currentFrame += 1
        if currentFrame % imageCount == 0 {
            currentFrame = 0
        }
    }

    private func setImage(frameCount: Int) {
        let imagePath = "\(imageNamePattern!)\(frameCount)"
        let image = NSImage(named: NSImage.Name(imagePath))

        image?.isTemplate = true // best for dark mode
        DispatchQueue.main.async {
            self.statusBarItem.button?.image = image
        }
    }
}
