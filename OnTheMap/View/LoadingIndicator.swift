//
//  LoadingIndicator.swift
//  OnTheMap
//
//  Created by Oleh Titov on 08.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation
import UIKit

struct LoadingIndicator {
    static func rotate(object: UIImageView) {
        UIView.animate(withDuration: 1, animations: {
            object.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }) { finished in
            object.transform = .identity
        }
    }
    
    static func hideElements(spinner: UIImageView, darkenView: UIView, hiden: Bool) {
        spinner.isHidden = hiden
        darkenView.isHidden = hiden
    }
    
    static func addSpinner() -> UIImageView {
        let spinner = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        spinner.image = UIImage(named: "spinner")
        return spinner
    }
    
    static func addDarkenView() -> UIView {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let darkenView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        darkenView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return darkenView
    }
}
