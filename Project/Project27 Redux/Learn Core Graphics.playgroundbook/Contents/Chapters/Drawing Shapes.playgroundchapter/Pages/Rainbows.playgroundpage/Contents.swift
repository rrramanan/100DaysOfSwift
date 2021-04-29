//#-hidden-code
import UIKit
let imageView = UIImageView()
//#-end-hidden-code
//: # Taste the rainbow
//: Your boss has dug out some old code that was supposed to draw a rainbow by stroking the outlines of concentric circles. Sadly, it looks like the data got corrupted somehow, because three of its values don't seem right.
//:
//: - Experiment: Your designer has produced a sketch showing how it *should* look. Can you adjust the code to help make it work correctly?
let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    ctx.cgContext.setLineWidth(50)

    let colors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple]
    var xPos = 0
    var yPos = 500
    var size = 1000

    for color in colors {
        xPos += /*#-editable-code amount to move horizontally*/100/*#-end-editable-code*/
        yPos += /*#-editable-code amount to move vertically*/0/*#-end-editable-code*/
        size -= /*#-editable-code amount to shrink each circle*/0/*#-end-editable-code*/

        var rect = CGRect(x: xPos, y: yPos, width: size, height: size)
        color.setStroke()
        ctx.cgContext.strokeEllipse(in: rect)
    }
}

imageView.image = rendered

//#-hidden-code
sendValue(rendered)
//#-end-hidden-code
