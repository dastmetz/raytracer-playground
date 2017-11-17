//
//  GridView.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 23.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation
import UIKit


class GridView: UIView, RenderShapeViewDelegate{
    
    var renderModelDelegate: RenderModelDelegate?
    var shapes = [RenderShape]()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        let longpressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(GridView.didTap(_:)))
        self.gestureRecognizers = [longpressRecognizer]
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func draw(_ rect: CGRect) {        
        let width = self.frame.width
        let height = self.frame.height
        let x1: CGFloat = 0.0
        let x2: CGFloat = width
        let y1: CGFloat = 0.0
        let y2: CGFloat = height
        
        let fieldSize = width/10
        let lineWidth: CGFloat = 1.5
        let pathColor = UIColor.lightGray.cgColor
        
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(lineWidth)
        context!.setStrokeColor(pathColor)
        
        // draw verticel lines
        var i: CGFloat = 0.0
        while i<(rect.height-fieldSize){
            let startPoint = CGPoint(x: fieldSize + i, y: y1)
            let endPoint = CGPoint(x: fieldSize + i, y: y2)
            context?.move(to: startPoint)
            context?.addLine(to: endPoint)
            i += fieldSize
        }
        
        // draw horizontal line
        var j: CGFloat = 0.0
        while (j<rect.width-fieldSize) {
            let startPoint = CGPoint(x: x1, y: fieldSize + j)
            let endPoint = CGPoint(x: x2, y: fieldSize + j)
            context?.move(to: startPoint)
            context?.addLine(to: endPoint)
            j += fieldSize
        }
        
        // draw glow
        context?.setShadow(offset: CGSize.zero, blur: 4.0, color: pathColor)
        context?.strokePath()
        context?.scaleBy(x: 1.5, y: 1.5)
    }
    
    @objc
    public func didTap( _ tapGR: UILongPressGestureRecognizer){
        print("Tap recognized")
        if (tapGR.state == UIGestureRecognizerState.began){
            print("Tap began")
            let tapPoint = tapGR.location(in: self)
            addShape(position: tapPoint)
        }
    }
    
    public func addShape(position: CGPoint){
        let renderShape = RenderShape(frame: CGRect(x: position.x-RenderShape.standardSize/2,
                                                    y: position.y-RenderShape.standardSize/2,
                                                    width: RenderShape.standardSize,
                                                    height: RenderShape.standardSize))
        renderShape.delegate = self
        self.addSubview(renderShape)
        renderModelDelegate?.addShapeToRenderList(renderShape: renderShape)
    }
    
    func discardShape(renderShape: RenderShape) {
        print("discard action")
        guard let _ = subviews.index(of: renderShape) else {
            print("Error - Rendershape not in list")
            return
        }
        renderModelDelegate?.removeShapeFromRenderList(renderShape: renderShape)
        renderShape.removeFromSuperview()
        print("Shape removed")
    }
    
    func growShape(renderShape: RenderShape) {
        renderModelDelegate?.updateRenderShapeSize(shape: renderShape)
    }
    
    func changedSelected(selected: RenderShape) {
        renderModelDelegate?.updateSelection(selected: selected)
    }
    
    func shapeUpdated() {
        renderModelDelegate?.updateRaytracer()
    }

    
}
