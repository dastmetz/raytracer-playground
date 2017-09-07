import Foundation
import UIKit

class ProgressView: UIView{
    
    var container = UIView()
    var progressCircle = UIActivityIndicatorView()
    var progressWindow = UIView()
    
    func showProgress( _ view: UIView){
        print("Started Progress View")
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        
        progressWindow.frame = CGRect(x: 0, y: 0,
                              width: 100, height: 100)
        progressWindow.layer.cornerRadius = 10
        progressWindow.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        progressWindow.center = view.center
        
        progressCircle.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        progressCircle.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        progressCircle.center = CGPoint(x: progressWindow.frame.size.width/2,
                                        y: progressWindow.frame.size.height/2)
        
        progressWindow.addSubview(progressCircle)
        container.addSubview(progressWindow)
        view.addSubview(container)
        progressCircle.startAnimating()
    }
    
    func dismissProgress(_ view: UIView){
        progressCircle.stopAnimating()
        container.removeFromSuperview()
    }
    
}
