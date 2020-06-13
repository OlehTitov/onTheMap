//
//  CurrentStudent.swift
//  OnTheMap
//
//  Created by Oleh Titov on 06.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation

class CurrentStudent {
    
    struct Location: Codable {
        static var uniqueKey: String {
            return UdacityClient.Auth.accountKey
        }
        static var firstName: String {
            return UdacityClient.Auth.firstName
        }
        static var lastName: String {
            return UdacityClient.Auth.lastName
        }
        //Assigned at AddLocationVC when find location tapped
        static var mapString: String = ""
        
        //Assigned at ConfirmLocationVC when Submit button tapped
        static var mediaURL: String = ""
        static var latitude: Double = 0
        static var longitude: Double = 0
        static var placeName: String = ""
        static var objectId: String = ""
    }
}
