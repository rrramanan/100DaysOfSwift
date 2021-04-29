import UIKit
import PlaygroundSupport

let liveView = LiveViewController()

liveView.drawPreview { ctx in
    UIColor.green.setFill()
    ctx.cgContext.fill(CGRect(x: 0, y: 0, width: 1000, height: 1000))

    UIColor.blue.setFill()
    ctx.cgContext.fill(CGRect(x: 400, y: 0, width: 200, height: 1000))
    ctx.cgContext.fill(CGRect(x: 0, y: 400, width: 1000, height: 200))
}

PlaygroundPage.current.liveView = liveView
