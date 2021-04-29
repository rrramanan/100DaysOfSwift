//#-hidden-code
import UIKit
let imageView = UIImageView()
//#-end-hidden-code
//: # Fixing the fade
//: This time you'll see the image now contains five rectangles, each 200 pixels wide and the full height of the image. Your designer wanted to make them red, orange, yellow, green, and blue, but they didn't get some of the colors quite right – they look faded.
//:
//: - Experiment: Can you draw the five rectangles in their correct colors? The first one has been done for you.
let rect = CGRect(x: 0, y: 0, width: 1000, height: 1000)
let renderer = UIGraphicsImageRenderer(bounds: rect)

let rendered = renderer.image { ctx in
    UIColor.red.setFill()
    ctx.cgContext.fill(CGRect(x: 0, y: 0, width: 200, height: 1000))
    //#-editable-code Tap to add your drawing instructions
    //#-end-editable-code
}

imageView.image = rendered
//#-hidden-code
sendValue(rendered)
//#-end-hidden-code
