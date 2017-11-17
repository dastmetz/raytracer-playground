//
//  Pixel.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 25.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation

public struct Pixel {
    var red: UInt8
    var green: UInt8
    var blue: UInt8
    var alpha: UInt8
    
    public init(r: UInt8, g: UInt8, b: UInt8){
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = 255
    }
    
}
