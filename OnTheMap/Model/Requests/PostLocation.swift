//
//  PostLocation.swift
//  OnTheMap
//
//  Created by Oleh Titov on 07.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation

struct PostLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
