import Foundation
import UIKit

public extension UIColor{
    func toVec3()->Vec3{
        let tmpColor = CIColor(color: self)
        let red     = Float(tmpColor.red)
        let green   = Float(tmpColor.green)
        let blue    = Float(tmpColor.blue)
        
        return Vec3(x: red, y: green, z: blue)
    }
}
