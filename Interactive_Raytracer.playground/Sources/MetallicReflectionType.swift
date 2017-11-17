import Foundation

public class MetallicReflectionType: ReflectionType{
    var reflectionColor: Vec3
    var fuzz: Float = 0.4
    
    public init(refl: Vec3){
        self.reflectionColor = refl
    }
    
    public func spread(inRay: Ray, outRay: inout Ray, intersection: Intersection, loss: inout Vec3) -> Bool {
        let normalizedInputDirection = normalizeVec3(vec: inRay.direction)
        let reflected = reflect(v: normalizedInputDirection, n: intersection.normal)
        outRay = Ray(start: intersection.p,
                     direction: reflected + (fuzz * inRay.getRandomPointOnSphere() ))
        loss = reflectionColor
        return dot(left: outRay.direction, right: intersection.normal) > 0
    }
}
