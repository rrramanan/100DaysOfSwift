//#-hidden-code
import UIKit
let imageView = UIImageView()
//#-end-hidden-code
//: # Writing on the wall
//: If you have an `NSAttributedString`, you can render it directly to a Core Graphics context just by saying where it should be drawn. All the string's attributes will be used for rendering, including its font, size, color, and more.
//:
//: - Experiment: Someone has been putting up inspirational posters around your office, saying "The early bird catches the worm." Your designer wants your help to design a modified version that says "But the second mouse gets the cheese" in red text 100 pixels below. Can you write code to match their sketch?
let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    let firstPosition = rect.offsetBy(dx: 0, dy: 300)
    let firstText = "The early bird catches the worm."
    let firstAttrs: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 72),
        .foregroundColor: UIColor.blue
    ]

    let firstString = NSAttributedString(string: firstText, attributes: firstAttrs)
    firstString.draw(in: firstPosition)
    //#-editable-code Tap to add your drawing instructions
    //#-end-editable-code
}

imageView.image = rendered

//#-hidden-code
sendValue(rendered)
//#-end-hidden-code
