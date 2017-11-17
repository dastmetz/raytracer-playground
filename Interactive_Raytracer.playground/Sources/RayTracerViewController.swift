//
//  ViewController.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 23.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import UIKit

enum CustomError : Error {
    case RuntimeError(String)
}

public class RayTracerViewController: UIViewController, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, ColorPickerDelegate {
    
    var gridContainer: GridContainer!
    var imageView: UIImageView?
    var progressView = ProgressView()
    var reflectionSelection = UISegmentedControl()
    var colorSelection = UIView()
    var renderShapes = [RenderShape : ShapeDescriptor]()
    
    static let renderController = RenderController()
    var renderDelegate: RayTracer?
    
    // stackViews =
    var mainStackView: UIStackView!
    var imageStackView : UIStackView!
    
    // for testing
    static let imageViewWidth = 400
    static let imageViewHeight = 200
    let gridWidth:CGFloat = 400
    let gridHeight:CGFloat = 400
    
    public func setup(){
        do {
            view.backgroundColor = UIColor.black
            try setupStackViews()
            colorSelection.layer.cornerRadius  = 5
            colorSelection.layer.masksToBounds = true
        }
        catch{
            print("Error setting up layout")
        }
    }
    
    @objc
    public func selectMaterial(_ segment: UISegmentedControl){
        if(segment.selectedSegmentIndex == 0){ // diffus
            renderDelegate?.updateSelectedShapeReflection(newReflection: .Diffus)
        } else if(segment.selectedSegmentIndex == 1) { // metallic
            renderDelegate?.updateSelectedShapeReflection(newReflection: .Metallic)
        }
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @objc
    public func colorPickerAction( _ sender: UIButton){
        let colorPicker = ColorPickerViewController()
        colorPicker.modalPresentationStyle = .popover
        colorPicker.preferredContentSize = CGSize(width: 200, height: 20)
        if let controller = colorPicker.popoverPresentationController {
            controller.sourceView = sender
            controller.delegate = self
            controller.backgroundColor = UIColor.clear
            controller.presentedView?.layer.shadowColor = UIColor.black.cgColor
            controller.sourceRect = CGRect(x: 0, y: 0, width: sender.bounds.width+10, height: sender.bounds.height+10)
        }
        colorPicker.delegate = self
        present(colorPicker, animated: true, completion: nil)
    }
    
    func colorChanged(color: UIColor) {
        self.colorSelection.backgroundColor = color
        print("Color Changed: \(renderDelegate)")
        renderDelegate?.updateSelectedShapeColor(newColor: color)
    }
    
    public func generateRandomScene(){
        
    }
    
    
    public func setImage(image: CIImage){
        imageView?.image = UIImage(ciImage: image)
    }
    
    public func removeShapeFromRenderList(renderShape: RenderShape) {
        guard let _ = renderShapes[renderShape] else {
            print("Error - Rendershape not in list")
            return
        }
        renderShapes.removeValue(forKey: renderShape )
    }
    
    
    public func convertToGridPosition(shape: RenderShape)->CGPoint{
        return gridContainer.gridView.convert(shape.center, to: gridContainer.gridView)
    }
    
    
    func getRenderPosition(gridPoint:  CGPoint, _ rad : Float)->Vec3{
        let gridPointX = Float(gridPoint.x)
        let gridPointY = Float(gridPoint.y)
        
        let cameraPositionGridX = Float(gridContainer.camera.center.x)
        let cameraPositionGridY = Float(gridContainer.gridView.bounds.maxY)
        
        let camPosRenderer = Vec3(x: 0, y: 0.5, z: 2)
        let diffX = Double(cameraPositionGridX - gridPointX) / Double(gridContainer.gridView.frame.width)
        let diffY = Double(cameraPositionGridY - gridPointY) / Double(gridContainer.gridView.frame.height)
        
        return Vec3(x: camPosRenderer.x + Float(diffX),
                    y: 0,
                    z: camPosRenderer.z - Float(diffY))
    }
    
    
    
    func updateRenderShapeSize(shape: RenderShape){
        guard let curr = renderShapes[shape] else { return }
        
        var scale: CGFloat?
        var newSize: SizeDescriptor?
        switch curr.size{
        case .Big :
            scale = -50
            newSize = SizeDescriptor.Small
            break
        case .Medium :
            scale = 25
            newSize = SizeDescriptor.Big
            break
        case .Small :
            scale = 25
            newSize = SizeDescriptor.Medium
            break
        }
        shape.grow(scale: scale!)
        renderShapes[shape] = ShapeDescriptor(refl: curr.reflection,
                                              col: curr.color,
                                              size: newSize!)
    }
    
    
    func startProgressIndicator(){
        progressView.showProgress(self.imageView!)
    }
    
    func stopProgressIndicator(){
        progressView.dismissProgress(self.imageView!)
    }
    
    func changeReflectionSelection(newReflection: ReflectionDescriptor){
        switch newReflection{
        case .Diffus:
            reflectionSelection.selectedSegmentIndex = 0
            break
        case .Metallic:
            reflectionSelection.selectedSegmentIndex = 1
            break
        }
        
    }
    
    
    
    func setupStackViews() throws {
        guard let _ = renderDelegate else { return }
        mainStackView = LayoutHelper.createMainStackView()
        imageStackView = LayoutHelper.createImagePanel()
        
        gridContainer = GridContainer(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2), delegate: renderDelegate!)
        
        //let gridPanel = LayoutHelper.createGridPanel(gridContainer)
        let settingsPanel = LayoutHelper.createSettingsPanel(self)
        settingsPanel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // add imageView to imagePanel
        imageView = UIImageView()
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.backgroundColor = UIColor.clear
        imageView!.widthAnchor.constraint(equalToConstant: CGFloat(RayTracerViewController.imageViewWidth)).isActive = true
        imageView!.heightAnchor.constraint(equalToConstant: CGFloat(RayTracerViewController.imageViewHeight)).isActive = true
        imageStackView.addArrangedSubview(imageView!)
        imageView?.topAnchor.constraint(equalTo: imageStackView.topAnchor).isActive = true
        imageView?.bottomAnchor.constraint(equalTo: imageStackView.bottomAnchor).isActive = true
        
        mainStackView.addArrangedSubview(imageStackView)
        mainStackView.addArrangedSubview(settingsPanel)
        mainStackView.addArrangedSubview(gridContainer)
        
        view.addSubview(mainStackView)
        
        // Setup Stackview constraints
        mainStackView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainStackView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        settingsPanel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        settingsPanel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: view.frame.width/5).isActive = true
        settingsPanel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: view.frame.width/5).isActive = true
        settingsPanel.topAnchor.constraint(equalTo: imageStackView.bottomAnchor, constant: 10).isActive = true
        
        
        gridContainer.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10).isActive = true
        gridContainer.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: 10).isActive = true
        gridContainer.topAnchor.constraint(equalTo: settingsPanel.bottomAnchor, constant: 20).isActive = true
        
        imageStackView.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor).isActive = true
        imageView?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gridContainer.centerXAnchor.constraint(equalTo: settingsPanel.centerXAnchor).isActive = true
        
        
    }
    
    
}

