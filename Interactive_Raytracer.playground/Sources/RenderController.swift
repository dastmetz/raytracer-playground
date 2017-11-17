//
//  RenderController.swift
//  RayTracer
//
//  Created by Daniel Steinmetz on 25.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation
import CoreImage

public class RenderController {
    
    static let sharedInstance = RenderController()
    static var maxRenderObjectSize: Float = 0.5
    var standardGroundColor: Vec3 = Vec3(x: 255/255, y: 51/255, z: 51/255)
    
    
    var antialiasingEnabled = true
    var samplingRate = 10
    var scene = Scene()
    var camera = Camera(aspect: Float(RayTracerViewController.imageViewWidth/RayTracerViewController.imageViewHeight))
    
    
    public func createRenderImage(width: Int, height: Int) -> CIImage{
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        scene.createRenderOrder()
        let pixelSet = calculatePixels(width: width, height)
        let bitsProPixel = 32
        let bitsProComponent = 8
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let dataProvider = CGDataProvider(data: NSData(bytes: pixelSet,
                                                       length: pixelSet.count * MemoryLayout<Pixel>.size))
        let tmpImage = CGImage(width: width,
                               height: height,
                               bitsPerComponent: bitsProComponent,
                               bitsPerPixel: bitsProPixel,
                               bytesPerRow: width * MemoryLayout<Pixel>.size,
                               space: colorSpace,
                               bitmapInfo: bitmapInfo,
                               provider: dataProvider!,
                               decode: nil,
                               shouldInterpolate: true,
                               intent: CGColorRenderingIntent.defaultIntent)
        return CIImage(cgImage: tmpImage!)
    }
    
    public func calculatePixels(width: Int, _ height: Int) -> [Pixel]{
        var pixel = Pixel(r: 0, g: 0, b: 0)
        var pixels = [Pixel](repeating: pixel, count: height * width)
        for w in 0..<width{
            for h in 0..<height{
                let color = calculateColor(wIndex: w, hIndex: h, width: width, height: height)
                pixel = Pixel(r: UInt8(color.x * 255),
                              g: UInt8(color.y * 255),
                              b: UInt8(color.z * 255) )
                pixels[w + h * width] = pixel
            }
        }
        return pixels
    }
    
    public  func setAntiAliasing(value: Bool){
        self.antialiasingEnabled = value
    }
    
    // anti aliasing by averaging color values with noise
    private func averageColor(wIndex: Int, hIndex: Int, width: Int, height: Int)->Vec3{
        var color = Vec3()
        let samples = 0..<samplingRate
        for _ in samples {
            let u = (Float(wIndex) + Float(drand48())) / Float(width)
            let v = (Float(hIndex) + Float(drand48())) / Float(height)
            let ray = camera.createRay(u: u, v: v)
            color = color + ray.color(world: self.scene, depth: 0)
        }
        let tmp = Vec3(x: Float(samplingRate), y: Float(samplingRate), z: Float(samplingRate))
        color = color / tmp
        color = Vec3(x: sqrt(color.x), y: sqrt(color.y), z: sqrt(color.z))
        return color
    }
    
    
    private func calculateColor(wIndex: Int, hIndex: Int, width: Int, height: Int)->Vec3{
        if antialiasingEnabled {
            return averageColor(wIndex: wIndex, hIndex: hIndex, width: width, height: height)
        }
        let u = Float(wIndex) / Float(width)
        let v = Float(hIndex) / Float(height)
        
        let ray = camera.createRay(u: u, v: v)
        return ray.color(world: scene, depth: 0)
    }
    
    public func rotateCamera(angle: Float, aspect: Float){
        print("Old Look at position: \(camera.standardLookAt)")
        let oldLookAt = camera.standardLookAt
        let newX = oldLookAt.x * cos(angle) + oldLookAt.z * sin(angle)
        let lookAt = Vec3(x: -newX, y: 0, z: 1)
        print("New Look at position: \(lookAt)")
        camera.rotateCamera(lookAt: lookAt)
        
    }
    
    public func changeFieldOfView(_ fov: Float){
        camera.setFieldOfView(fov)
    }
    
    public func changeReflection(_ reflection: ReflectionType){
        for object in (scene.values as? [Sphere])!{
            object.setReflection(reflection: reflection)
        }
    }
    
    
    
    
}
