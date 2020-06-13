//
//  gradientBackground.swift
//  OnTheMap
//
//  Created by Oleh Titov on 27.05.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation
import UIKit

class gradientBackground: UIViewController {
    
    func setGradientBackground() {
        let colorTop =  UIColor.portage.cgColor
        let colorBottom = UIColor.pinkLace.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}
