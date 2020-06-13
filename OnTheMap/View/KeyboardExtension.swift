//
//  KeyboardExtension.swift
//  OnTheMap
//
//  Created by Oleh Titov on 28.05.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController {
    
    
    //Start tracking when keyboard appears
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Stop tracking when keyboard appears
    func unsubscribeFromKeyboardNotifications() {
        //Remove all notification without specifying exact name
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        //Move the entire view up if the textfield is edited
        
        if email.isEditing {
            print(getKeyboardHeight(notification))
            view.frame.origin.y -= calculateDifference(field: email, notification)
            password.isEnabled = false
        } else {
            view.frame.origin.y -= calculateDifference(field: password, notification)
            email.isEnabled = false
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        //Return image view to its normal place
        view.frame.origin.y = 0
        password.isEnabled = true
        email.isEnabled = true
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func calculateDifference(field: UITextField, _ notification: Notification) -> CGFloat {
        return field.frame.origin.y - getKeyboardHeight(notification)
    }
}
