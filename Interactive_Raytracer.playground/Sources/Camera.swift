//
//  Camera.swift
//  RayTracer-iOS
//

import Foundation

public class Camera {
    var standardLookAt = Vec3(x: 0, y: 0, z: 1)
    var position = Vec3(x: 0, y: 0.25, z: 2) // camera is slighlty above the spheres positioned
    var lowerLeft = Vec3(x: -2.0, y: 1.0, z: -1.0)
    var horizontal = Vec3(x: 4.0, y: 0, z: 0)
    var vertical = Vec3(x: 0, y: -2.0, z: 0)
    var fieldOfView: Float = 100
    var aspect: Float!
    
    
    public init(aspect: Float){
        self.aspect = aspect
        rotateCamera(lookAt: standardLookAt)
    }
    
    public func rotateCamera(lookAt: Vec3){
        let vup = Vec3(x: 0, y: -1, z: 0)
        let t = fieldOfView * Float(M_PI) / 180
        let tmpHeight = tan(t/2)
        let tmpWidth  = tmpHeight * aspect
        let d = position - lookAt
        let normalizedDistance = normalizeVec3(vec: d)
        let c = cross(a: vup, b: normalizedDistance)
        let u = normalizeVec3(vec: c)
        let v = cross(a: normalizedDistance, b: u)
        self.lowerLeft = position - (tmpWidth * u) - (tmpHeight * v) - normalizedDistance
        self.horizontal = tmpWidth * 2 * u
        self.vertical = tmpHeight * 2 * v
    }
    
    public func createRay(u: Float, v: Float)-> Ray{
        let direction = (u * horizontal) + (v * vertical) + lowerLeft - position
        return Ray(start: self.position, direction: direction)
    }
    
    
    public func setFieldOfView(_ fov: Float){
        if  (50 <= fov) && (fov <= 100) {
            fieldOfView = fov
        } else {
            fieldOfView = 100 // standard fov
        }
    }
}

