import UIKit
import PlaygroundSupport

let liveView = LiveViewController()

let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)

liveView.drawPreview { ctx in
    UIColor.darkGray.setFill()
    ctx.cgContext.fill(rect)

    UIColor.black.setFill()
    let borderRect = CGRect(x: 0, y: 0, width: 640, height: 640)
    ctx.cgContext.fill(borderRect)
}

PlaygroundPage.current.liveView = liveView
