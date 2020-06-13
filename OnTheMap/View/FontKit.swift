//
//  FontKit.swift
//  OnTheMap
//
//  Created by Oleh Titov on 03.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//  Solution taken from: https://stackoverflow.com/questions/61291811/how-to-implement-uikit-sf-pro-rounded

import UIKit

class FontKit {
    
    static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: weight)
        let font: UIFont
        
        if #available(iOS 13.0, *) {
            if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
                font = UIFont(descriptor: descriptor, size: fontSize)
            } else {
                font = systemFont
            }
        } else {
            font = systemFont
        }
        
        return font
    }
}
