import Foundation
import UIKit

public class GridContainer: UIView {
    
    var gridView: GridView
    var camera: CameraShape
    var modelDelegate: RayTracer
    
   public init(frame: CGRect, delegate: RayTracer) {
        modelDelegate = delegate
        self.gridView = GridView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        camera = CameraShape(frame: CGRect(origin: CGPoint(x: gridView.bounds.width/2 - 80, y: gridView.bounds.height-20), size: CGSize(width: 160, height: 80)))
        super.init(frame: frame)
        gridView.renderModelDelegate = modelDelegate
        addSubview(gridView)
        addSubview(camera)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        gridView.setNeedsDisplay()
    }
    
    public func setupLayout(){
        gridView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        gridView.widthAnchor.constraint(equalToConstant: 350).isActive = true
    }
    
    
}
