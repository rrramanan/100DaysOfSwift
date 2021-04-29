//#-hidden-code
import UIKit
let imageView = UIImageView()
//#-end-hidden-code
//: # The Poppyseed Bread Company
//: You have a new client! A local artisanal bakery always adds a finishing touch to its loaves by sprinkling poppy seeds on top, and they want you to make them a great poppy logo. Your designer has already sketched something, but it falls to you to figure out how to make it happen in code.
//:
//: - Experiment: You can see your designer's sketch below: four red circles, with a black circle in the middle. Can you make this happen using ellipses? They've drawn the first one for you, but it isn't quite right.
let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    //#-editable-code Tap to add your drawing instructions
    UIColor.red.setFill()
    let circle1 = CGRect(x: 0, y: 0, width: 500, height: 500)
    ctx.cgContext.fillEllipse(in: circle1)
    //#-end-editable-code
}

imageView.image = rendered

//#-hidden-code
sendValue(rendered)
//#-end-hidden-code
