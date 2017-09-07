//
//  RenderShape.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 23.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation
import UIKit



public class RenderShape: ShapeView{

    var delegate: RenderShapeViewDelegate?
    let buttonSize = 36
    var discardButton = UIButton()
    
    static var growthRatio = 1.5
    static var standardSize: CGFloat = 100.0
    
    var shapeColor = UIColor.darkGray
    

    override public init(frame: CGRect){
        super.init(frame: frame)
        setup()
        clipsToBounds = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        backgroundColor = UIColor.clear
        addDiscardButton()
        
    }
    
    override public func draw(_ rect: CGRect) {
        print("Current Color: \(shapeColor.description)")
        let circle = CAShapeLayer()
        var circleBounds = CGRect(x:10,
                                  y: 10,
                                  width: self.bounds.width * 0.75,
                                  height: self.bounds.height * 0.75)
        
    
        circle.path = UIBezierPath(ovalIn: circleBounds).cgPath
        circle.fillColor =  shapeColor.cgColor
        if isSeleted{
            circle.shadowColor = UIColor.white.cgColor
            circle.shadowOffset = CGSize(width: 0, height: 0)
            circle.shadowOpacity = 1
            circle.masksToBounds = false
            circle.shadowRadius = 5
        }
        if let currentContext = UIGraphicsGetCurrentContext(){
            circle.render(in: currentContext)
        }
    }
    
    override public func detectPan(_ recognizer: UIPanGestureRecognizer) {
        super.detectPan(recognizer)
        if recognizer.state == UIGestureRecognizerState.ended{
            delegate?.shapeUpdated()
        }
    }
    
    private func addDiscardButton(){
        discardButton = DiscardButton(frame: CGRect(x: -buttonSize/2, y: -buttonSize/2, width: buttonSize, height: buttonSize))
        discardButton.addTarget(self, action: #selector(RenderShape.discardShape), for: .touchDown)
        discardButton.isHidden = true
        self.addSubview(discardButton)
    }
    
    public func discardShape(){
        print("Discard Button Pressed")
        delegate?.discardShape(renderShape: self)
    }
    
    
    public func detectTap(_ tap: UITapGestureRecognizer){
        if isSeleted{
            delegate?.growShape(renderShape: self)
        } else {
            isSeleted = true
            setNeedsDisplay()
            delegate?.changedSelected(selected: self)
            
        }
    }
    
    // Animations
    
    override public func startShaking() {
        super.startShaking()
        discardButton.isHidden = false
    }
    
    override public func stopShaking() {
        super.stopShaking()
        discardButton.isHidden = true
    }
    
    public func grow(scale: CGFloat){
        contentMode = UIViewContentMode.redraw
        UIView.animate(withDuration: 0.75) { 
            var newBounds = self.bounds
            var center = self.center
            newBounds.size.height += scale
            newBounds.size.width += scale
           self.bounds = newBounds
        self.center = center
        }
    }
    

}
