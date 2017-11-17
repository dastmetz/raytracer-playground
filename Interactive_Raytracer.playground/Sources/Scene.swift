import Foundation

public class Scene: RayIntersection{
    
    public var center = Vec3(x: 0, y: -200.5, z: -1)  // center of ground sphere
    let groundReflection = Vec3(x: 255/255, y: 51/255, z: 51/255) // reflectionColor of ground sphere
    
    var values = [RayIntersection]()
    
    public init(){
    }
    
    public func addIntersection(x: RayIntersection){
        values.append(x)
    }
    
    public func intersect(ray: Ray, intersection: inout Intersection) -> Bool {
        var intersected = false
        for item in values {
            if (item.intersect(ray: ray, intersection: &intersection))  {
                intersected = true
            }
        }
        return intersected
    }
    
    // sort objects by distance to camera and add ground sphere
    public func createRenderOrder(){
        var completeScene = [RayIntersection]()
        let ground = Sphere(center: center,
                            radius: 200,
                            mat: DiffusReflectionType(reflVal: groundReflection))
        
        completeScene.append(ground)
        let sortToCameraPos =  values.sorted { (a, b) -> Bool in
            a.center.z < b.center.z
        }
        completeScene.append(contentsOf: sortToCameraPos)
        values = completeScene
    }
    
    public func reset(){
        values = [RayIntersection]()
    }
}
