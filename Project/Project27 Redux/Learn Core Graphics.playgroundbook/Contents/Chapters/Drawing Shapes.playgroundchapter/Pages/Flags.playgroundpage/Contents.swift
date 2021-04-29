//#-hidden-code
import UIKit
let imageView = UIImageView()
//#-end-hidden-code
//: # One nation under Swift
//: Impressed with your rectangle drawing prowess, your designer has returned to ask for help in designing a flag for the United Republic of Swiftovia.
//:
//: The client asked for a solid background color with a nice and bright cross over it, but they didn't like the colors chosen by your designer.
//:
//: - Experiment: Recreate your designer's image, but this time using a yellow background and an orange cross. Your designer wrote a couple of lines for you, which should give you a headstart.
let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    //#-editable-code Tap to add your drawing instructions
    UIColor.orange.setFill()
    ctx.cgContext.fill(CGRect(x: 0, y: 400, width: 1000, height: 200))
    //#-end-editable-code
}

imageView.image = rendered
//#-hidden-code
sendValue(rendered)
//#-end-hidden-code
