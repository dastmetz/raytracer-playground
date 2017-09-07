//
//  Ray.swift
//  RayTracer
//
//  Created by Daniel Steinmetz on 25.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation

public struct Ray {
    var start: Vec3
    var direction: Vec3
    
   public func positionAt(_ scalar: Float) -> Vec3{
        return start + ( scalar * direction )
    }
    
    // only working with spheres
    public func color(world: RayIntersection, depth: Int) -> Vec3{
        
        var intersection = Intersection()
        if world.intersect(ray: self, intersection: &intersection){
            guard let _ = intersection.reflectionType else {
                print("massive error")
                return Vec3()
            }
            var rayToSpread = self
            var loss = Vec3()
            if ((depth < 50) && (intersection.reflectionType!.spread(inRay: self, outRay: &rayToSpread, intersection: intersection, loss: &loss)) ) {
                let test = rayToSpread.color(world: world, depth: depth + 1)
                return loss * test
            } else {
                return Vec3(x: 0.9, y: 0.9, z: 0.9)
            }
        } else {
            let unitDirection =  normalizeVec3(vec: self.direction)
            let t = 0.5 * (unitDirection.y + 1.0)
            return (1.0 - t) * Vec3(x: 1, y: 1, z: 1) + t * Vec3(x: 75/255, y: 165/255, z: 238/255) // color of sky
        }
        
    }
    
    func getRandomPointOnSphere()->Vec3{
        var tmpPoint = Vec3()
        repeat {
            tmpPoint = 2.0 * 2.0 * Vec3(x: Float(drand48()), y: Float(drand48()), z: Float(drand48())) - Vec3(x: 1, y: 1, z: 1)
        } while dot(left: tmpPoint, right: tmpPoint) >= 1.0
        
        return tmpPoint
    }

    
}
