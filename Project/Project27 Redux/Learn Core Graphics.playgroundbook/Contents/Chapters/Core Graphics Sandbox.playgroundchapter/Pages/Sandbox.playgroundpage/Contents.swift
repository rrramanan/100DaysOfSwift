//#-hidden-code
import UIKit
let imageView = UIImageView()
//#-end-hidden-code
//: # Sandbox
//: *Sandbox - noun: a place where people can play. (In the sand.)*
//:
//: Below are some example Core Graphics instructions based on things you've learned in this playground. This is a great place to experiment by copying, pasting, and experimenting until you get the result you want – enjoy!
let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    //#-editable-code Tap to add your drawing instructions
    UIColor.green.setFill()
    UIColor.black.setStroke()
    ctx.cgContext.setLineWidth(10)
    ctx.cgContext.addRect(CGRect(x: 50, y: 500, width: 150, height: 150))
    ctx.cgContext.drawPath(using: .fillStroke)

    let firstText = "Here's to the crazy ones"
    let firstAttrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 72),
        .foregroundColor: UIColor.blue
    ]

    ctx.cgContext.setLineWidth(20)
    ctx.cgContext.move(to: CGPoint(x: 50, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 100, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 150, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 200, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 250, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 300, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 350, y: 300))
    ctx.cgContext.addLine(to: CGPoint(x: 400, y: 350))
    ctx.cgContext.addLine(to: CGPoint(x: 450, y: 300))
    ctx.cgContext.strokePath()

    let string = NSAttributedString(string: firstText, attributes: firstAttrs)
    string.draw(in: rect)

    UIColor.red.setFill()
    ctx.cgContext.setBlendMode(.xor)
    ctx.cgContext.fillEllipse(in: CGRect(x: 700, y: 400, width: 200, height: 200))
    ctx.cgContext.fillEllipse(in: CGRect(x: 600, y: 400, width: 200, height: 200))
    ctx.cgContext.setBlendMode(.normal)

    if let image = UIImage(named: "saltire") {
        ctx.cgContext.rotate(by: .pi / 8)
        image.draw(at: CGPoint(x: 600, y: 400))
    }

    //#-end-editable-code
}

imageView.image = rendered

//#-hidden-code
sendValue(rendered)
//#-end-hidden-code
