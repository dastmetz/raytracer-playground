//
//  Protocols.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 24.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation


protocol RenderShapeViewDelegate {
    func discardShape(renderShape: RenderShape)
    func growShape(renderShape: RenderShape)
    func changedSelected(selected: RenderShape)
    func shapeUpdated()
}

protocol RenderModelDelegate{
    func removeShapeFromRenderList(renderShape: RenderShape)
    func addShapeToRenderList(renderShape: RenderShape)
    func updateRenderShapeSize(shape: RenderShape)
    func updateSelection(selected: RenderShape)
    func updateRaytracer()
}

