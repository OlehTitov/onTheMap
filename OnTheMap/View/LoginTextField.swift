//
//  LoginTextField.swift
//  OnTheMap
//
//  Created by Oleh Titov on 29.05.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 20)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
        tintColor = UIColor.white
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
