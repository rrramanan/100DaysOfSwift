//#-hidden-code
import UIKit
let imageView = UIImageView()
//#-end-hidden-code
//: # Spin class
//: Your designer is very pleased this morning, because they've designed a neat geometric shape for a client logo. It might look complicated, but really it's just eight squares with each one rotated by 45 degrees around its bottom-left corner.
//:
//: Your designer tried writing the Core Graphics code themselves, but things aren't going to plan: they don't have enough boxes, and the ones they *do* have are all being drawn in the top-left corner.
//:
//: Part of the problem is that Core Graphics measures angles in *radians*: if you rotate by `.pi` radians it's the same as rotating 180 degrees, and if you rotate `.pi / 4` radians it's the same as rotating 45 degrees.
//:
//: - Experiment: Can you fix this code so that it draws the designer's sketch as they want? You might want to start by adjusting the `translateBy()` call.
let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let boxRectangle = CGRect(x: 0, y: 0, width: 300, height: 300)

let rendered = renderer.image { ctx in
    ctx.cgContext.setLineWidth(8)
    //#-editable-code Tap to add your drawing instructions
    ctx.cgContext.translateBy(x: 0, y: 0)

    for _ in 1...6 {
        ctx.cgContext.addRect(boxRectangle)
        ctx.cgContext.rotate(by: .pi / 3)
    }
    //#-end-editable-code

    UIColor.red.setStroke()
    ctx.cgContext.strokePath()
}

imageView.image = rendered

//#-hidden-code
sendValue(rendered)
//#-end-hidden-code
