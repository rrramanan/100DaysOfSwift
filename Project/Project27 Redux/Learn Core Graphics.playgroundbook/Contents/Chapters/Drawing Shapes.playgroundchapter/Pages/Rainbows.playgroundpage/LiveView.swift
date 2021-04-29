import UIKit
import PlaygroundSupport

let liveView = LiveViewController()

liveView.drawPreview { ctx in
    ctx.cgContext.setLineWidth(50)

    let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
    var xPos = 0
    var yPos = 500
    var size = 1000

    for color in colors {
        xPos += 50
        yPos += 50
        size -= 100

        var rect = CGRect(x: xPos, y: yPos, width: size, height: size)
        color.withAlphaComponent(0.2).setStroke()
        ctx.cgContext.strokeEllipse(in: rect)
    }
}

PlaygroundPage.current.liveView = liveView
