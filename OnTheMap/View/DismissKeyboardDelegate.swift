//
//  DismissKeyboardDelegate.swift
//  OnTheMap
//
//  Created by Oleh Titov on 28.05.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation
import UIKit

class DismissKeyboardDelegate: NSObject, UITextFieldDelegate {
    
    //Hide keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
