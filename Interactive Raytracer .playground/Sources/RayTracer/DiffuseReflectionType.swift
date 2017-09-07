//
//  
//  RayTracer-iOS
//

import Foundation

public class DiffusReflectionType: ReflectionType{
    
    var reflectionColor: Vec3
    
    public init(reflVal: Vec3){
        self.reflectionColor = reflVal
    }
    
    public func spread(inRay: Ray, outRay: inout Ray, intersection: Intersection, loss: inout Vec3) -> Bool {
        let destination = intersection.p + intersection.normal + inRay.getRandomPointOnSphere()
        outRay = Ray(start: intersection.p, direction: (destination - intersection.p))
        loss = self.reflectionColor
        return true
    }
    
}
