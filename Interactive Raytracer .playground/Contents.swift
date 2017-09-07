import UIKit

//: **Raytracing** - noun: a technique for creating a two dimensional representation of a virtual scene by tracing the path of light.

let rayTracer = RayTracer()

//: ![Basic principle Raytracer](Sketch1.png)

//: The core principle of a Raytracer as seen above is to send rays through a grid of pixels (the image plane) to compute the color of the ray in this direction. Change the color literal below and watch how the color of shape in the updated calculated image changes.



let shapeColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

rayTracer.setShapeColor(color: shapeColor)



//: ![Diffuse reflection](Sketch2.png)

//: The calculated color depends on the object's surface and it's reflection type. The above sketch shows how a sphere with a diffuse surface is reflecting light in random directions. Below you can switch between the two reflection types, diffus and glossy-metallic.

let reflectionProperty = ReflectionDescriptor.Diffus
rayTracer.setShapeReflection(newReflection: reflectionProperty)

//: Let's switch to fully interactive mode. On the right side you can create a custom scene. Therefor, press on the the grid to add a new shape. You can modify the shape, move it around the surface, switch between different sizes by tapping it or remove it via longpress. Have fun.    

rayTracer.start()



