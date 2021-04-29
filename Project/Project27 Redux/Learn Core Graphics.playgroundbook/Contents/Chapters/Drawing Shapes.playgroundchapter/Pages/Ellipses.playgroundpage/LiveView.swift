import UIKit
import PlaygroundSupport

let liveView = LiveViewController()

liveView.drawPreview { ctx in
    UIColor.red.setFill()
    var circle = CGRect(x: 0, y: 0, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle)
}

PlaygroundPage.current.liveView = liveView
