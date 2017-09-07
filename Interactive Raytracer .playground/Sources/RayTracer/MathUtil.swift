//
//  MathUtil.swift
//  RayTracer
//
//  Created by Daniel Steinmetz on 25.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation
import simd


public struct Vec3 {
    
    var x: Float = 0.0
    var y: Float = 0.0
    var z: Float = 0.0
    
    public init(){
    
    }
    
    public init(x: Float, y: Float, z: Float){
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(f: float3){
        self.x = f.x
        self.y = f.y
        self.z = f.z
    }
    
}

public func dot(left: Vec3, right: Vec3)->Float{
    return (left.x * right.x + left.y * right.y + left.z * right.z)
}

public func unitVector(vec: Vec3) -> Vec3 {
    let tmp = float3(x: vec.x, y: vec.y, z: vec.z)
    let length = sqrt(dot(tmp, tmp))
    return Vec3(x: vec.x/length,
                y: vec.y/length,
                z: vec.z/length)
}

public func * (scalar: Float, vector: Vec3) -> Vec3{
    return Vec3(x: vector.x * scalar,
                y: vector.y * scalar,
                z: vector.z * scalar)
}

public func * (a: Vec3, b: Vec3) -> Vec3{
    return Vec3(x: a.x * b.x,
                y: a.y * b.y,
                z: a.z * b.z)
}

public func / (vector: Vec3, div: Float) -> Vec3{
    
    return Vec3(x: vector.x/div,
                y: vector.y/div,
                z: vector.z/div)
}

public func / (a: Vec3, b: Vec3) -> Vec3{
    return Vec3(x: a.x / b.x,
                y: a.y / b.y,
                z: a.z / b.z)
}

public func + (left: Vec3, right: Vec3)->Vec3{
    return Vec3(x: left.x + right.x,
                y: left.y + right.y,
                z: left.z + right.z)
}

public func - (left: Vec3, right: Vec3)->Vec3{
    return Vec3(x: left.x - right.x,
                y: left.y - right.y,
                z: left.z - right.z)
}

public func normalizeVec3(vec: Vec3) -> Vec3 {
    let lengthSquare = vec.x * vec.x + vec.y * vec.y + vec.z * vec.z
    if (lengthSquare ~= 0) || (lengthSquare ~= 1){
        return vec
    }
    return Vec3(x: vec.x / sqrt(lengthSquare),
                y: vec.y / sqrt(lengthSquare),
                z: vec.z / sqrt(lengthSquare))
}

public func cross(a: Vec3, b: Vec3) -> Vec3{
    let x = (a.y * b.z) - (a.z * b.y)
    let y = (a.z * b.x) - (a.x * b.z)
    let z = (a.x * b.y) - (a.y * b.x)
    
    return Vec3(x: x, y: y, z: z)
}



