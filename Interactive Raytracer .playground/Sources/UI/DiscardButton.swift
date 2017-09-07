//
//  DiscardButton.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 24.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation
import UIKit

public class DiscardButton: UIButton{
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 0.5 * self.frame.width
        clipsToBounds = true
        backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        UIColor.black.setStroke()
        
        let path = UIBezierPath()
        path.lineWidth = 3.0
        
        let topLeft = CGPoint(x: layer.cornerRadius*0.5, y: layer.cornerRadius*0.5)
        let bottomRight =  CGPoint(x: layer.cornerRadius*1.5, y: layer.cornerRadius*1.5)
        path.move(to: topLeft)
        path.addLine(to: bottomRight)

        let bottomLeft = CGPoint(x: layer.cornerRadius*0.5, y: layer.cornerRadius*1.5)
        let topRight = CGPoint(x: layer.cornerRadius*1.5, y: layer.cornerRadius*0.5)
        path.move(to: bottomLeft)
        path.addLine(to: topRight)
        path.stroke()
    }
}
