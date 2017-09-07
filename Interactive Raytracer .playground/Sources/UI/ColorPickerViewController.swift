//
//  ColorPickerView.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 30.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import UIKit
import CoreGraphics

protocol ColorPickerDelegate {
    func colorChanged(color: UIColor)
}

class ColorPickerViewController: UIViewController{
    
    let sizeOfColorElement: CGFloat = 20
    var pickerView: ColorPickerView?
    var delegate: ColorPickerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView = ColorPickerView(frame: view.bounds)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ColorPickerViewController.colorSelected(_ :)))
        pickerView!.addGestureRecognizer(tap)
        view.addSubview(pickerView!)
        pickerView!.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    public func colorSelected( _ recognizer: UITapGestureRecognizer){
        let color = getColorForPoint(point: recognizer.location(in: pickerView))
        delegate?.colorChanged(color: color)
        self.presentingViewController!.dismiss(animated: true, completion: nil)

    }
    
    
    
    public func getColorForPoint(point: CGPoint)->UIColor{
        let indexOfColorField = CGFloat(point.x / sizeOfColorElement) * sizeOfColorElement
        return UIColor(hue: indexOfColorField / 350,
                       saturation: 1,
                       brightness: 1,
                       alpha: 1)
    }
    
}


class ColorPickerView: UIView{
    
    let sizeOfColorElement: CGFloat = 20
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for x in stride(from: (0 as CGFloat), to: 350, by: sizeOfColorElement) {
            let hue = x / 350
            let color = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0).cgColor
            context!.setFillColor(color)
            context!.fill(CGRect(x:x, y:0, width:sizeOfColorElement,height:sizeOfColorElement))
        }
        
    }
    
    
}
