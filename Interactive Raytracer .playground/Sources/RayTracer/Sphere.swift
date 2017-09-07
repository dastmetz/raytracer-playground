//
//  Sphere.swift
//  RayTracer
//
//  Created by Daniel Steinmetz on 25.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation

public protocol RayIntersection{
    var center: Vec3 {get set}
    func intersect(ray: Ray, intersection: inout Intersection)->Bool
}


public struct Intersection {
    var t: Float // length of ray start to intersection
    var p: Vec3  // position if intersection on sphere
    var normal: Vec3
    var reflectionType: ReflectionType?
    
    public init(){
        p = Vec3(x: 0.0, y: 0.0, z: 0.0)
        t = 0.0
        normal = Vec3(x: 0.0, y: 0.0, z: 0.0)
    }
}

class Sphere: RayIntersection {
    
    var center = Vec3()
    var radius: Float = 0.0
    var material: ReflectionType
    let tmin: Float = 0.01
    let tmax: Float = Float.infinity
    
    public init(center: Vec3, radius: Float, mat: ReflectionType){
        self.center = center
        self.radius = radius
        self.material = mat
    }
    
    func intersect(ray: Ray, intersection: inout Intersection) -> Bool{
        let sphereNormal = ray.start - center
        let a = dot(left: ray.direction, right: ray.direction)
        let b = dot(left:  sphereNormal, right: ray.direction)
        let c = dot(left: sphereNormal, right: sphereNormal) - (self.radius * self.radius)
        let d = b * b -  a * c
        
        if (d <= 0){
            return false
        } else {
            var tmp = (-b - sqrt(d)) / a                                       //// Wurzel rechnung separieren
            if(tmin < tmp && tmp < tmax){
                intersection.t = tmp
                intersection.p = ray.positionAt(intersection.t)
                intersection.normal = (intersection.p - center) / radius
                intersection.reflectionType = material
                return true
            }
            tmp = (-b + sqrt(d)) / a                                           
            if (tmin < tmp && tmp < tmax){
                intersection.t = tmp
                intersection.p = ray.positionAt(intersection.t)
                intersection.normal = (intersection.p - center)/radius
                intersection.reflectionType = material
                return true
            }
            
        }
        return false
    }
    
    func setReflection(reflection: ReflectionType){
        self.material = reflection
    }
    
}





