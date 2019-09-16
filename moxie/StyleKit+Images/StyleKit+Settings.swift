//
//  StyleKit+Settings.swift
//  moxie
//
//  Created by Tomoki Takasawa on 9/21/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//



import UIKit

extension StyleKit {
    
    //// Drawing Methods
    
    class func drawSettings(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 361, height: 47), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 361, height: 47), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 361, y: resizedFrame.height / 47)
        
        
        //// Color Declarations
        let textForeground = UIColor(red: 0.298, green: 0.298, blue: 0.298, alpha: 1.000)
        let fillColor3 = UIColor(red: 0.392, green: 0.385, blue: 0.436, alpha: 1.000)
        let color = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 1.000)
        let bOrderColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 0.107)
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 8.5, y: 0.5))
        bezierPath.addLine(to: CGPoint(x: 352.5, y: 0.5))
        bezierPath.addCurve(to: CGPoint(x: 360.5, y: 8.5), controlPoint1: CGPoint(x: 356.92, y: 0.5), controlPoint2: CGPoint(x: 360.5, y: 4.08))
        bezierPath.addLine(to: CGPoint(x: 360.5, y: 38.5))
        bezierPath.addCurve(to: CGPoint(x: 352.5, y: 46.5), controlPoint1: CGPoint(x: 360.5, y: 42.92), controlPoint2: CGPoint(x: 356.92, y: 46.5))
        bezierPath.addLine(to: CGPoint(x: 8.5, y: 46.5))
        bezierPath.addCurve(to: CGPoint(x: 0.5, y: 38.5), controlPoint1: CGPoint(x: 4.08, y: 46.5), controlPoint2: CGPoint(x: 0.5, y: 42.92))
        bezierPath.addLine(to: CGPoint(x: 0.5, y: 8.5))
        bezierPath.addCurve(to: CGPoint(x: 8.5, y: 0.5), controlPoint1: CGPoint(x: 0.5, y: 4.08), controlPoint2: CGPoint(x: 4.08, y: 0.5))
        bezierPath.close()
        color.setFill()
        bezierPath.fill()
        bOrderColor.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
        
        
        //// Label Drawing
        let labelRect = CGRect(x: 18, y: 7, width: 71.73, height: 30)
        let labelTextContent = "Settings"
        let labelStyle = NSMutableParagraphStyle()
        labelStyle.alignment = .center
        let labelFontAttributes = [
            .font: UIFont(name: "SFProDisplay-Medium", size: 20)!,
            .foregroundColor: textForeground,
            .paragraphStyle: labelStyle,
            ] as [NSAttributedStringKey: Any]
        
        let labelTextHeight: CGFloat = labelTextContent.boundingRect(with: CGSize(width: labelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: labelFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: labelRect)
        labelTextContent.draw(in: CGRect(x: labelRect.minX, y: labelRect.minY + (labelRect.height - labelTextHeight) / 2, width: labelRect.width, height: labelTextHeight), withAttributes: labelFontAttributes)
        context.restoreGState()
        
        
        //// Bezier 6 Drawing
        let bezier6Path = UIBezierPath()
        bezier6Path.move(to: CGPoint(x: 339, y: 22))
        bezier6Path.addLine(to: CGPoint(x: 337.7, y: 22))
        bezier6Path.addCurve(to: CGPoint(x: 336.8, y: 19.9), controlPoint1: CGPoint(x: 337.5, y: 21.3), controlPoint2: CGPoint(x: 337.2, y: 20.6))
        bezier6Path.addLine(to: CGPoint(x: 337.7, y: 19))
        bezier6Path.addCurve(to: CGPoint(x: 337.7, y: 16.2), controlPoint1: CGPoint(x: 338.5, y: 18.2), controlPoint2: CGPoint(x: 338.5, y: 17))
        bezier6Path.addCurve(to: CGPoint(x: 334.9, y: 16.2), controlPoint1: CGPoint(x: 336.9, y: 15.4), controlPoint2: CGPoint(x: 335.7, y: 15.4))
        bezier6Path.addLine(to: CGPoint(x: 334, y: 17.1))
        bezier6Path.addCurve(to: CGPoint(x: 331.9, y: 16.2), controlPoint1: CGPoint(x: 333.4, y: 16.7), controlPoint2: CGPoint(x: 332.7, y: 16.4))
        bezier6Path.addLine(to: CGPoint(x: 331.9, y: 15))
        bezier6Path.addCurve(to: CGPoint(x: 329.9, y: 13), controlPoint1: CGPoint(x: 331.9, y: 13.9), controlPoint2: CGPoint(x: 331, y: 13))
        bezier6Path.addCurve(to: CGPoint(x: 327.9, y: 15), controlPoint1: CGPoint(x: 328.8, y: 13), controlPoint2: CGPoint(x: 327.9, y: 13.9))
        bezier6Path.addLine(to: CGPoint(x: 327.9, y: 16.3))
        bezier6Path.addCurve(to: CGPoint(x: 325.9, y: 17.1), controlPoint1: CGPoint(x: 327.3, y: 16.5), controlPoint2: CGPoint(x: 326.6, y: 16.7))
        bezier6Path.addLine(to: CGPoint(x: 325.1, y: 16.2))
        bezier6Path.addCurve(to: CGPoint(x: 322.3, y: 16.2), controlPoint1: CGPoint(x: 324.3, y: 15.4), controlPoint2: CGPoint(x: 323.1, y: 15.4))
        bezier6Path.addCurve(to: CGPoint(x: 322.3, y: 19), controlPoint1: CGPoint(x: 321.5, y: 17), controlPoint2: CGPoint(x: 321.5, y: 18.2))
        bezier6Path.addLine(to: CGPoint(x: 323.2, y: 19.9))
        bezier6Path.addCurve(to: CGPoint(x: 322.3, y: 22), controlPoint1: CGPoint(x: 322.7, y: 20.6), controlPoint2: CGPoint(x: 322.5, y: 21.3))
        bezier6Path.addLine(to: CGPoint(x: 321, y: 22))
        bezier6Path.addCurve(to: CGPoint(x: 319, y: 24), controlPoint1: CGPoint(x: 319.9, y: 22), controlPoint2: CGPoint(x: 319, y: 22.9))
        bezier6Path.addCurve(to: CGPoint(x: 321, y: 26), controlPoint1: CGPoint(x: 319, y: 25.1), controlPoint2: CGPoint(x: 319.9, y: 26))
        bezier6Path.addLine(to: CGPoint(x: 322.3, y: 26))
        bezier6Path.addCurve(to: CGPoint(x: 323.2, y: 28.1), controlPoint1: CGPoint(x: 322.5, y: 26.7), controlPoint2: CGPoint(x: 322.8, y: 27.4))
        bezier6Path.addLine(to: CGPoint(x: 322.3, y: 29))
        bezier6Path.addCurve(to: CGPoint(x: 322.3, y: 31.8), controlPoint1: CGPoint(x: 321.5, y: 29.8), controlPoint2: CGPoint(x: 321.5, y: 31))
        bezier6Path.addCurve(to: CGPoint(x: 325.1, y: 31.8), controlPoint1: CGPoint(x: 323.1, y: 32.6), controlPoint2: CGPoint(x: 324.3, y: 32.6))
        bezier6Path.addLine(to: CGPoint(x: 326, y: 30.9))
        bezier6Path.addCurve(to: CGPoint(x: 328.1, y: 31.8), controlPoint1: CGPoint(x: 326.6, y: 31.3), controlPoint2: CGPoint(x: 327.3, y: 31.6))
        bezier6Path.addLine(to: CGPoint(x: 328.1, y: 33))
        bezier6Path.addCurve(to: CGPoint(x: 330.1, y: 35), controlPoint1: CGPoint(x: 328.1, y: 34.1), controlPoint2: CGPoint(x: 329, y: 35))
        bezier6Path.addCurve(to: CGPoint(x: 332.1, y: 33), controlPoint1: CGPoint(x: 331.2, y: 35), controlPoint2: CGPoint(x: 332.1, y: 34.1))
        bezier6Path.addLine(to: CGPoint(x: 332.1, y: 31.7))
        bezier6Path.addCurve(to: CGPoint(x: 334.2, y: 30.8), controlPoint1: CGPoint(x: 332.8, y: 31.5), controlPoint2: CGPoint(x: 333.5, y: 31.2))
        bezier6Path.addLine(to: CGPoint(x: 335.1, y: 31.7))
        bezier6Path.addCurve(to: CGPoint(x: 337.9, y: 31.7), controlPoint1: CGPoint(x: 335.9, y: 32.5), controlPoint2: CGPoint(x: 337.1, y: 32.5))
        bezier6Path.addCurve(to: CGPoint(x: 337.9, y: 28.9), controlPoint1: CGPoint(x: 338.7, y: 30.9), controlPoint2: CGPoint(x: 338.7, y: 29.7))
        bezier6Path.addLine(to: CGPoint(x: 337, y: 28))
        bezier6Path.addCurve(to: CGPoint(x: 337.9, y: 25.9), controlPoint1: CGPoint(x: 337.4, y: 27.4), controlPoint2: CGPoint(x: 337.7, y: 26.7))
        bezier6Path.addLine(to: CGPoint(x: 339, y: 25.9))
        bezier6Path.addCurve(to: CGPoint(x: 341, y: 23.9), controlPoint1: CGPoint(x: 340.1, y: 25.9), controlPoint2: CGPoint(x: 341, y: 25))
        bezier6Path.addCurve(to: CGPoint(x: 339, y: 22), controlPoint1: CGPoint(x: 341, y: 22.9), controlPoint2: CGPoint(x: 340.1, y: 22))
        bezier6Path.close()
        bezier6Path.move(to: CGPoint(x: 330, y: 27))
        bezier6Path.addCurve(to: CGPoint(x: 327, y: 24), controlPoint1: CGPoint(x: 328.3, y: 27), controlPoint2: CGPoint(x: 327, y: 25.7))
        bezier6Path.addCurve(to: CGPoint(x: 330, y: 21), controlPoint1: CGPoint(x: 327, y: 22.3), controlPoint2: CGPoint(x: 328.3, y: 21))
        bezier6Path.addCurve(to: CGPoint(x: 333, y: 24), controlPoint1: CGPoint(x: 331.7, y: 21), controlPoint2: CGPoint(x: 333, y: 22.3))
        bezier6Path.addCurve(to: CGPoint(x: 330, y: 27), controlPoint1: CGPoint(x: 333, y: 25.7), controlPoint2: CGPoint(x: 331.7, y: 27))
        bezier6Path.close()
        fillColor3.setFill()
        bezier6Path.fill()
        
        context.restoreGState()
        
    }
    
}
