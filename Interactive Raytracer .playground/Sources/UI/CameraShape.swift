//
//  CameraShape.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 23.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation
import UIKit

public class CameraShape: UIView {
    
    var previousLocation = CGPoint(x: 0, y: 0)
    //var transformation: CGAffineTransform!
    
    var rotationDegree: Float = 0
    //var currentRotationDifference: CGFloat?
  //  var originalTransformation: CGAffineTransform?
    
    override public init(frame: CGRect){
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func draw(_ rect: CGRect) {
        let color = UIColor.white
        color.setStroke()
        
        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 39.5, y: 31.5, width: 80, height: 30))
        rectanglePath.lineWidth = 2
        rectanglePath.stroke()
        
        
        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 39.5, y: 23.5))
        bezier2Path.addCurve(to: CGPoint(x: 45.9, y: 23.5), controlPoint1: CGPoint(x: 39.5, y: 23.5), controlPoint2: CGPoint(x: 41.91, y: 23.5))
        bezier2Path.addCurve(to: CGPoint(x: 119.5, y: 23.5), controlPoint1: CGPoint(x: 64.86, y: 23.5), controlPoint2: CGPoint(x: 119.5, y: 23.5))
        bezier2Path.addCurve(to: CGPoint(x: 101.72, y: 31.5), controlPoint1: CGPoint(x: 113.7, y: 26.11), controlPoint2: CGPoint(x: 107.49, y: 28.91))
        bezier2Path.addLine(to: CGPoint(x: 57.28, y: 31.5))
        bezier2Path.addCurve(to: CGPoint(x: 39.5, y: 23.5), controlPoint1: CGPoint(x: 51.51, y: 28.91), controlPoint2: CGPoint(x: 45.3, y: 26.11))
        bezier2Path.addLine(to: CGPoint(x: 39.5, y: 23.5))
        bezier2Path.close()
        bezier2Path.lineWidth = 2
        bezier2Path.stroke()
    
    }
    
    /*
    func rotateCamera(gesture: UIRotationGestureRecognizer){
        return
        
        let  oldRotationRadians = atan2f(Float(self.originalTransformation!.b), Float(self.originalTransformation!.a))
        let  currentRotationRad = atan2f(Float(self.transform.b), Float(self.transform.a))
        let oldRotationDeg = oldRotationRadians * Float(90 / M_PI_2)
        let currentRotationDeg = currentRotationRad * Float(90 / M_PI_2)
        let diff = CGFloat(oldRotationDeg - currentRotationDeg)
        
        if (0<=abs(diff) && abs(diff)<=90){ // allow only rotation between -90 and 90 degree
            self.transform = self.transform.rotated(by: gesture.rotation)
            currentRotationDifference = -diff
        }
        
        if gesture.state == UIGestureRecognizerState.ended{
            print("Rotation von Ursprung aus \(currentRotationDifference)")
            self.rotationDegree = Float(currentRotationDifference!)
        }
    
        gesture.rotation = 0
    }
 */
    
    /*
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        transformation = self.transform
        return true
    }*/
}
