//
//  Alerts.swift
//  OnTheMap
//
//  Created by Oleh Titov on 05.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//  Inspiration is taken here:
//  https://stackoverflow.com/questions/44030213/whats-the-swift-best-practice-for-reusable-uialertcontroller-configuration-via-e

import Foundation
import UIKit

enum AlertTitles: String {
    case loginFailed = "Login failed"
    case logoutFailed = "Logout failed"
    case searchFailed = "Search failed"
    case invalidURL = "Invalid URL"
    case refreshFailed = "Refresh failed"
    case repeatedSubmission = "You have already submitted your location"
    case failureToPost = "Saving location failed"
}

enum AlertMessages: String {
    case searchFailed = "Could not find that place on the map. Please try again."
    case invalidURLWhenBrowsing = "Sorry, but this student added an invalid URL. Check another student!"
    case invalidURLWhenAdding = "Please enter a valid URL"
    case repeatedSubmission = "Do you really want to resubmit your location and URL?"
    case failureToPost = "Please try again later"
}

struct Alerts {
    static func errorAlert(title: String, message: String?, cancelButton: Bool = false, completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) {
            _ in
            guard let completion = completion else { return }
            completion()
        }
        alert.addAction(actionOK)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if cancelButton { alert.addAction(cancel) }
        
        return alert
    }
}
