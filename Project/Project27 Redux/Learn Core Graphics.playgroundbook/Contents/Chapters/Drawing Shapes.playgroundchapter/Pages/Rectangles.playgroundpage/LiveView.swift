import UIKit
import PlaygroundSupport

let liveView = LiveViewController()

liveView.drawPreview { ctx in
    UIColor.blue.setFill()
    ctx.cgContext.fill(CGRect(x: 200, y: 200, width: 600, height: 600))
}

PlaygroundPage.current.liveView = liveView
