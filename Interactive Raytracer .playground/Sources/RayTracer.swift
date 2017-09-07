import Foundation
import UIKit
import PlaygroundSupport



public class RayTracer: RenderModelDelegate {
    
    let vc: RayTracerViewController
    var renderShapes = [RenderShape : ShapeDescriptor]()
    var selectedShape: RenderShape?
    var renderable: Bool = true
    
    
    private var _shapeColor = UIColor.darkGray
    var shapeColor: UIColor {
        get {
            return _shapeColor
        }
        set(newColor) {
            updateShapes(newColor: newColor)
            vc.colorSelection.backgroundColor = newColor
            vc.gridContainer.setNeedsDisplay()
            _shapeColor = newColor
        }
    }
    
    public init() {
        vc = RayTracerViewController()
        vc.view.frame = CGRect(x: 0, y: 0, width: 400, height: 800)
        vc.renderDelegate = self
        vc.setup()
        createInitialScene()
        PlaygroundPage.current.liveView = vc
    }

    public func start(){
        setupScene()
        self.vc.startProgressIndicator()
        DispatchQueue.global(qos: .userInitiated).async {
            let image = RenderController.sharedInstance.createRenderImage(width: RayTracerViewController.imageViewWidth,
                                                                          height: RayTracerViewController.imageViewHeight)
            DispatchQueue.main.async {
                self.vc.setImage(image: image)
                self.vc.stopProgressIndicator()
                
            }
        }
    }
    
    public func setGroundColor(color: UIColor){
        RenderController.sharedInstance.standardGroundColor = color.toVec3()
    }
    
    public func setShapeColor(color: UIColor){
        self.shapeColor = color
    }
    
    public func setShapeReflection(newReflection: ReflectionDescriptor){
        updateShapes(newReflection)
    }
   
    
    private func setupScene(){
        RenderController.sharedInstance.scene.reset()
        print("Objects to render \(renderShapes.count)")
        for (shape, descr) in renderShapes {
            let gridPosition = vc.convertToGridPosition(shape: shape)
            let radius = getRenderSize(shape: shape, desc: descr)
            let renderPosition =  vc.getRenderPosition(gridPoint: gridPosition, radius)
            let reflection = descr.getReflection()
            let object = Sphere(center: renderPosition, radius: radius, mat: reflection)
            
            RenderController.sharedInstance.scene.addIntersection(x: object)
        }
    }
    
    
    private  func getRenderSize(shape: RenderShape, desc: ShapeDescriptor) -> Float{
        var size: CGFloat?
        switch desc.size {
        case .Small:
            size = 75/2
            break
        case .Medium:
            size = 100/2
            break
        case .Big:
            size = 125/2
            break
        }
        let maxSizeRenderShape:CGFloat = RenderShape.standardSize * CGFloat(RenderShape.growthRatio)
        let ratio = size!/maxSizeRenderShape
        return Float(ratio) * RenderController.maxRenderObjectSize
    }

    public func createInitialScene(){
        let centerPoint = CGPoint(x: vc.gridContainer.gridView.frame.width/2,
                                  y: vc.gridContainer.gridView.frame.height/2)
        addShapeToGrid(point: centerPoint)   // add a sphere in center
    }
    
  
    
    private func updateShapes(newColor: UIColor){
        for (shape, descriptor) in renderShapes {
            var newDescriptor = descriptor
            // update rendershape accordingly
            shape.shapeColor = newColor
            shape.setNeedsDisplay()
            newDescriptor.color = newColor.toVec3()
            renderShapes[shape] = newDescriptor
        }
    }
    
    private func addShapeToGrid(point: CGPoint){
        vc.gridContainer.gridView.addShape(position: point)
    }
    
    private func updateShapes(_ newReflection: ReflectionDescriptor){
        for (shape, descriptor) in renderShapes{
            var newDescriptor = descriptor
            newDescriptor.reflection = newReflection
            renderShapes[shape] = newDescriptor
        }
    }
    
    public func updateSelectedShapeColor(newColor: UIColor){
        guard let _ = selectedShape else {
            print("No Shape selected")
            return
        }
        selectedShape?.shapeColor = newColor
        var newDescriptor = renderShapes[selectedShape!]
        let newColor = newColor.toVec3()
        newDescriptor?.color = newColor
        selectedShape?.setNeedsDisplay()
        renderShapes[selectedShape!] = newDescriptor
        start()
    }
    
    private func updateSelectionHighlightning(old: RenderShape, new: RenderShape){
        old.isSeleted = false
        new.isSeleted = true
        old.setNeedsDisplay()
        new.setNeedsDisplay()
    }
    
    
    public func updateSelectedShapeReflection(newReflection: ReflectionDescriptor){
        guard let _ = selectedShape else { return }
        
        var newDescriptor = renderShapes[selectedShape!]
        newDescriptor!.reflection = newReflection
        renderShapes[selectedShape!] = newDescriptor
        start()
    }

    
    // RenderModelDelegate
    
    public func removeShapeFromRenderList(renderShape: RenderShape) {
        guard let _ = renderShapes[renderShape] else {
            print("Error - Rendershape not in list")
            return
        }
        renderShapes.removeValue(forKey: renderShape )
        if let _ = selectedShape {
            if selectedShape!.isEqual(renderShape){
                selectedShape = nil
            }
        }
        print("Removed Element from Scene - Starting RayTracing")

    }
    
    public func addShapeToRenderList(renderShape: RenderShape) {
        renderShapes[renderShape] = ShapeDescriptor()
        print("Added Element to Scene - Starting RayTracing")
//        if let _ = selectedShape{
//            updateSelectionHighlightning(old: selectedShape!, new: renderShape)
//        }
        selectedShape = renderShape
        vc.colorSelection.backgroundColor = selectedShape?.shapeColor
        if renderable {
            start()
        }
    }
    
    public func updateRaytracer() {
        start()
    }
    
    func updateRenderShapeSize(shape: RenderShape){
        guard let curr = renderShapes[shape] else { return }
//        if let _ = selectedShape{
//            updateSelectionHighlightning(old: selectedShape!, new: shape)
//        }
        selectedShape = shape
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
        start()

    }
    
    
    // commands
    public func randomScene(){
        renderable = false
        let numberOfElements = arc4random_uniform(6) + 1
        for i in 0...numberOfElements{
            let point = getRandomPointOnGrid()
            print("Add \(point)")
            if (i == numberOfElements-1){
                renderable = true
            }
            addShapeToGrid(point: point)
        }
    }
    
    private func getRandomPointOnGrid()->CGPoint{
        let maxX = Int(vc.gridContainer.gridView.bounds.width - 50.0)
        let maxY = Int(vc.gridContainer.gridView.bounds.height - 50.0)
        let randomX = CGFloat(arc4random_uniform(UInt32(maxX)) + 50)
        let randomY = CGFloat(arc4random_uniform(UInt32(maxY)) + 50)
        return CGPoint(x: randomX, y: randomY)
    }
    
    func updateSelection(selected: RenderShape) {
        for (shape, _) in renderShapes {
            if !shape.isEqual(selected){
                shape.isSeleted = false
                shape.setNeedsDisplay()
            } else {
                self.selectedShape = selected
                if let reflectionDescriptor = renderShapes[selected]?.reflection{
                    vc.changeReflectionSelection(newReflection: reflectionDescriptor)
                    vc.colorSelection.backgroundColor = shape.shapeColor
                }
            }
        }
    }

    
}
