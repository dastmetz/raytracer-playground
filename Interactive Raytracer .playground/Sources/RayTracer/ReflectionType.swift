//
//  Material.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 29.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation

public enum Reflection {
    case Diffuse
    case Metallic
    
    public init?(val: Int){
        if (val == 1){
            self = .Metallic
        } else {
            self = .Diffuse
        }
    }
}

public protocol ReflectionType {
    func spread(inRay: Ray, outRay: inout Ray, intersection: Intersection, loss: inout Vec3) -> Bool
}

public func reflect(v: Vec3, n: Vec3) -> Vec3 {
    return v - 2*dot(left: v,right: n)*n;
}
