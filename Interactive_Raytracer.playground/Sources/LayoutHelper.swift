//
//  LayoutHelper.swift
//  RayTracer-iOS
//
//  Created by Daniel Steinmetz on 26.03.17.
//  Copyright © 2017 Daniel Steinmetz. All rights reserved.
//

import Foundation
import UIKit

struct LayoutHelper {

    static func createMainStackView() -> UIStackView{
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    static func createImagePanel() -> UIStackView{
        let imagePanel = UIStackView()
        imagePanel.axis = .vertical
        imagePanel.alignment = .top
        imagePanel.translatesAutoresizingMaskIntoConstraints = false
        return imagePanel
    }
    
    static func createGridPanel(_ grid: GridContainer) -> UIStackView{
        let gridPanel = UIStackView()
        gridPanel.axis = .horizontal
        gridPanel.alignment = .center
        gridPanel.spacing = 5
        gridPanel.translatesAutoresizingMaskIntoConstraints = false
        
        gridPanel.addArrangedSubview(grid)
        grid.translatesAutoresizingMaskIntoConstraints = false
        grid.gridView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        grid.gridView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        return gridPanel
    }
    
    static func createSettingsPanel(_ vc: RayTracerViewController)->UIStackView{
        let settingsRow = UIStackView()
        settingsRow.axis = .horizontal
        settingsRow.alignment = .top
        settingsRow.spacing = 20
        
        // setup reflection control
        vc.reflectionSelection.insertSegment(withTitle: "Diffus", at: 0, animated: false)
        vc.reflectionSelection.insertSegment(withTitle: "Metallic", at: 1, animated: false)
        vc.reflectionSelection.addTarget(self, action: #selector(RayTracerViewController.selectMaterial(_ : )), for: UIControlEvents.valueChanged)
        vc.reflectionSelection.tintColor = .white
        vc.reflectionSelection.selectedSegmentIndex = 0
        
        // setup color control
        vc.colorSelection.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let colorButton = UIButton(frame: vc.colorSelection.bounds)
        colorButton.addTarget(self, action: #selector(RayTracerViewController.colorPickerAction(_:)), for: UIControlEvents.touchDown)
        colorButton.backgroundColor = UIColor.clear
        vc.colorSelection.addSubview(colorButton)
        
        settingsRow.addArrangedSubview(vc.reflectionSelection)
        settingsRow.addArrangedSubview(vc.colorSelection)
        
        vc.colorSelection.translatesAutoresizingMaskIntoConstraints  = false
        vc.colorSelection.backgroundColor = UIColor.darkGray
        vc.colorSelection.heightAnchor.constraint(equalToConstant: vc.colorSelection.frame.height).isActive = true
        vc.colorSelection.widthAnchor.constraint(equalToConstant: vc.colorSelection.frame.width).isActive = true
        vc.reflectionSelection.heightAnchor.constraint(equalTo: vc.colorSelection.heightAnchor).isActive = true

        return settingsRow
        
    }

}
