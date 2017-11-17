//
//  ShapeView.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 23.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation
import UIKit

public class ShapeView: UIView {

    var currentLocation = CGPoint(x: 0, y: 0)
    var isShaking: Bool = false
    var dragStartPosition: CGPoint?
    var isSeleted: Bool = false

    
    override public init(frame: CGRect){
        super.init(frame: frame)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ShapeView.detectPan(_:)))
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(RenderShape.detectTap(_:)))
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ShapeView.detectLongTap(_:)))

        self.addGestureRecognizer(tapRecognizer)
        self.addGestureRecognizer(longTapRecognizer)
        self.addGestureRecognizer(panRecognizer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Gestures
    @objc
    public func detectPan(_ recognizer:UIPanGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.began{
            dragStartPosition = self.center
        }
        
        let translation  = recognizer.translation(in: self.superview)
        let translationPoint = CGPoint(x: currentLocation.x + translation.x, y: currentLocation.y + translation.y)
        if superview!.bounds.contains(translationPoint) {
            self.center = translationPoint
        }
        
        if recognizer.state == UIGestureRecognizerState.ended {
            let collisions = superview?.subviews.filter({ (tmpView) -> Bool in
                (tmpView != self) && (self.frame.intersects(tmpView.frame)) && (tmpView.isKind(of: RenderShape.self))
            })
            if(collisions!.count > 0){
                dragStartPosition = calculateValidPosition(shape: collisions!.first as! RenderShape )
                UIView.animate(withDuration: 0.6, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.center = self.dragStartPosition!
                }, completion: nil)
            }
            dragStartPosition = nil
        }
    }
    
    private func calculateValidPosition(shape: ShapeView) -> CGPoint{
        let tmp = self.frame
        let intersectionRect = shape.frame.intersection(tmp)
        var tmpX: CGFloat?
        var tmpY: CGFloat?
        if frame.origin.x >= shape.frame.origin.x && frame.origin.y <= shape.frame.origin.y{
            tmpX =  intersectionRect.maxX + intersectionRect.width + 10
            tmpY = intersectionRect.minY - (intersectionRect.height + 10)
        } else if frame.origin.x >= shape.frame.origin.x && frame.origin.y >= shape.frame.origin.y{
            tmpX =  intersectionRect.maxX + (intersectionRect.width + 10)
            tmpY = intersectionRect.minY + (intersectionRect.height + 10)
        } else if frame.origin.x < shape.frame.origin.x && frame.origin.y > shape.frame.origin.y{
            tmpX =  intersectionRect.minX - (intersectionRect.width + 10)
            tmpY = intersectionRect.maxY + (intersectionRect.height + 10)
        } else if frame.origin.x < shape.frame.origin.x && frame.origin.y < shape.frame.origin.y{
            tmpX =  intersectionRect.minX - (intersectionRect.width + 10)
            tmpY = intersectionRect.minY - (intersectionRect.height + 10)
        }
        
        
        let newCenter = CGPoint(x: tmpX!, y: tmpY!)
        
        return newCenter
    }
    
    @objc
    public func detectLongTap(_ recognizer: UILongPressGestureRecognizer) {
        if(recognizer.state == UIGestureRecognizerState.began){
            startShaking()
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubview(toFront: self)
        currentLocation = self.center
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isShaking{
            stopShaking()
        }
    }
    
    
    // Animation
    
    public func startShaking(){
        let shakeAnimation = CABasicAnimation(keyPath: "position")
        shakeAnimation.duration = 0.07
        shakeAnimation.repeatCount = HUGE
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 1, y: self.center.y-1))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 1, y: self.center.y+1))
        self.layer.add(shakeAnimation, forKey: "position")
        isShaking = true
    }
    
    public func stopShaking(){
        layer.removeAnimation(forKey: "position")
        isShaking = false
    }
    
}
