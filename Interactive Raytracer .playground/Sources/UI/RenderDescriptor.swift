//
//  RenderDescriptor.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 01.04.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation
import CoreGraphics

public enum ReflectionDescriptor{
    case Diffus
    case Metallic
}

public enum SizeDescriptor {
    case Small
    case Medium
    case Big
}

public struct ShapeDescriptor{
    var reflection: ReflectionDescriptor
    var color: Vec3
    var size: SizeDescriptor
    
    public init(){
        reflection = .Diffus
        color =  Vec3(x: 0.5, y: 0.5, z: 0.5)
        size = .Medium
    }
    
    public init(refl: ReflectionDescriptor, col: Vec3, size: SizeDescriptor){
        self.reflection = refl
        self.color = col
        self.size = size
    }
    
    public func getReflection()->ReflectionType{
        switch reflection {
        case ReflectionDescriptor.Diffus :
            return DiffusReflectionType(reflVal: color)
            
        case ReflectionDescriptor.Metallic:
            return MetallicReflectionType(refl: color)
        }
    }
    
    public func getShapeSize()-> CGFloat{
        switch size{
        case SizeDescriptor.Small:
            return 75.0
        case SizeDescriptor.Medium:
            return 100.0
        case SizeDescriptor.Big:
            return 125.0
            
        }
    }

}
