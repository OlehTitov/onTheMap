//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Oleh Titov on 02.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation

struct StudentInformation: Codable, Equatable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    let createdAt: String
    let updatedAt: String
}
