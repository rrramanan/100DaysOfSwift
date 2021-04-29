//
//  ViewController.swift
//  Project27
//
//  Created by R R on 18/02/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imagveView: UIImageView!
    var currentDrawType = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        drawRectangle()
    
       // view.backgroundColor = .darkGray
        
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1

        if currentDrawType > 9{
            currentDrawType = 0
        }

        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquare()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawTwin() //challenge
        case 7:
            drawEmoji1() //challenge
        case 8:
            drawEmoji2() //challenge

        default:
            break
        }
       
    }
    
    func drawRectangle(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            UIColor.red.setFill() // ** also
            //ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imagveView.image = image
        
    }

    
    func drawCircle(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let circle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: circle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imagveView.image = image
        
    }
    
    func drawCheckerBoard(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0{
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
            
        }
        
        imagveView.image = image
        
    }
    
    func drawRotatedSquare(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotation = 16
            let amount = Double.pi / Double(rotation)
            
            for _ in 0 ..< rotation{
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
            
        }
        
        imagveView.image = image
        
    }
    
    func drawLines(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256{
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first{
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                }else{
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imagveView.image = image
        
    }
    
    func drawImagesAndText(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
         
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            
            let attributedString = NSMutableAttributedString(string: string, attributes: attrs)
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
            
        }
        
        imagveView.image = image
        
    }
 
    
    
    //challenge ...
    func drawTwin(){
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
           
            ctx.cgContext.setStrokeColor(UIColor.orange.cgColor)
            ctx.cgContext.setLineWidth(5)
            
            //t
            ctx.cgContext.move(to: CGPoint(x: 100, y: 240))
            ctx.cgContext.addLine(to: CGPoint(x: 100, y: 300))
            
            ctx.cgContext.move(to: CGPoint(x: 80, y: 240))
            ctx.cgContext.addLine(to: CGPoint(x: 120, y: 240))
            
           //w
           
            ctx.cgContext.move(to: CGPoint(x: 160, y: 240))
            ctx.cgContext.addLine(to: CGPoint(x: 180, y: 300))

            ctx.cgContext.move(to: CGPoint(x: 200, y: 270))
            ctx.cgContext.addLine(to: CGPoint(x: 180, y: 300))

            ctx.cgContext.move(to: CGPoint(x: 200, y: 270))
            ctx.cgContext.addLine(to: CGPoint(x: 220, y: 300))

            ctx.cgContext.move(to: CGPoint(x: 240, y: 240))
            ctx.cgContext.addLine(to: CGPoint(x: 220, y: 300))
            
            //I
            
            ctx.cgContext.move(to: CGPoint(x: 280, y: 240))
            ctx.cgContext.addLine(to: CGPoint(x: 320, y: 240))

            ctx.cgContext.move(to: CGPoint(x: 300, y: 240))
            ctx.cgContext.addLine(to: CGPoint(x: 300, y: 300))
           
            ctx.cgContext.move(to: CGPoint(x: 280, y: 300))
            ctx.cgContext.addLine(to: CGPoint(x: 320, y: 300))
            
            
            //N
            
            ctx.cgContext.move(to: CGPoint(x: 380, y: 240))
            ctx.cgContext.addLine(to: CGPoint(x: 380, y: 300))

            ctx.cgContext.move(to: CGPoint(x: 380, y: 240))
            ctx.cgContext.addLine(to: CGPoint(x: 410, y: 300))
            
            ctx.cgContext.move(to: CGPoint(x: 410, y: 240))
            ctx.cgContext.addLine(to: CGPoint(x: 410, y: 300))
            
            ctx.cgContext.strokePath()
 
         
        }
        
        imagveView.image = image
    }
    
    func drawEmoji1(){
        let _ = "⭐️"
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
            //ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setLineWidth(5)
            
            //    top "/" & "\"
            ctx.cgContext.move(to: CGPoint(x: 220, y: 60))
            ctx.cgContext.addLine(to: CGPoint(x: 160, y: 180))
            
            ctx.cgContext.move(to: CGPoint(x: 220, y: 60))
            ctx.cgContext.addLine(to: CGPoint(x: 280, y: 180))
            
            //  "_" right & left"_"
            ctx.cgContext.move(to: CGPoint(x: 280, y: 180))
            ctx.cgContext.addLine(to: CGPoint(x: 400, y: 180))
            
            ctx.cgContext.move(to: CGPoint(x: 160, y: 180))
            ctx.cgContext.addLine(to: CGPoint(x: 40, y: 180))
            
            //    "\" below left & "/" below right
            ctx.cgContext.move(to: CGPoint(x: 40, y: 180))
            ctx.cgContext.addLine(to: CGPoint(x: 120, y: 300))
            
            ctx.cgContext.move(to: CGPoint(x: 400, y: 180))
            ctx.cgContext.addLine(to: CGPoint(x: 320, y: 300))
            
            // .. "/" <below left "\"> & "\" <below right "/">
            ctx.cgContext.move(to: CGPoint(x: 120, y: 300))
            ctx.cgContext.addLine(to: CGPoint(x: 70, y: 420))
            
            ctx.cgContext.move(to: CGPoint(x: 320, y: 300))
            ctx.cgContext.addLine(to: CGPoint(x: 370, y: 420))
            
            //     "/" <bottom left> & "\" <bottom right>
            ctx.cgContext.move(to: CGPoint(x: 220, y: 330))
            ctx.cgContext.addLine(to: CGPoint(x: 70, y: 420))
            
            ctx.cgContext.move(to: CGPoint(x: 220, y: 330))
            ctx.cgContext.addLine(to: CGPoint(x: 370, y: 420))
            
            ctx.cgContext.strokePath()
            
        }
        
        imagveView.image = image
        
    }
 
    
    func drawEmoji2(){
        let _ = "⭐️"   //star emoji wuth a modified func/shape from previous star
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            
            ctx.cgContext.setStrokeColor(UIColor.green.cgColor)
            ctx.cgContext.setLineWidth(5)
            
            // top "/" & "\"
            ctx.cgContext.addLines(between: [CGPoint(x: 220, y: 60),CGPoint(x: 160, y: 180)])
            ctx.cgContext.addLines(between: [CGPoint(x: 220, y: 60),CGPoint(x: 280, y: 180)])
            
            // "_" right & left"_"
            ctx.cgContext.addLines(between: [CGPoint(x: 280, y: 180),CGPoint(x: 400, y: 190)])
            ctx.cgContext.addLines(between: [CGPoint(x: 160, y: 180),CGPoint(x: 40, y: 190)])
                
            //   "\" below left & "/" below right
            ctx.cgContext.addLines(between: [CGPoint(x: 40, y: 190),CGPoint(x: 100, y: 300)])
            ctx.cgContext.addLines(between: [CGPoint(x: 400, y: 190),CGPoint(x: 340, y: 300)])
            
            //   .. "/" <below left "\"> & "\" <below right "/">
            ctx.cgContext.addLines(between: [CGPoint(x: 100, y: 300),CGPoint(x: 60, y: 420)])
            ctx.cgContext.addLines(between: [CGPoint(x: 340, y: 300),CGPoint(x: 380, y: 420)])
            
            //    "/" <bottom left> & "\" <bottom right>
            ctx.cgContext.addLines(between: [CGPoint(x: 60, y: 420),CGPoint(x: 220, y: 360)])
            ctx.cgContext.addLines(between: [CGPoint(x: 380, y: 420),CGPoint(x: 220, y: 360)])
            
            ctx.cgContext.strokePath()
            
        }
        
        imagveView.image = image
        
    }
    
   
    
}

