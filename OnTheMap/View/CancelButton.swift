//
//  CancelButton.swift
//  OnTheMap
//
//  Created by Oleh Titov on 13.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import UIKit

class CancelButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor.oxfordBlue.cgColor
        
    }
    
}
