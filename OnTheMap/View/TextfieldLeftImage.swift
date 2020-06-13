//
//  TextfieldLeftImage.swift
//  OnTheMap
//
//  Created by Oleh Titov on 08.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation
import UIKit

struct TextfiedLeftImage {
    static func addImage(textField: UITextField, image: UIImage) {
        let leftImageView = UIImageView(frame: CGRect(x: 10.0, y: 0.0, width: image.size.width, height: image.size.height))
        let container = UIView(frame: CGRect(x: 0.0, y: 0.0, width: image.size.width + 20, height: image.size.height))
        container.contentMode = UIView.ContentMode.right
        leftImageView.image = image
        textField.leftViewMode = .always
        container.addSubview(leftImageView)
        textField.leftView = container
    }
    
    static func styleLeftImage(imageName: String) -> UIImage {
        return UIImage(systemName: imageName)!.withTintColor(.systemGray3, renderingMode: .alwaysOriginal)
    }
    
}
