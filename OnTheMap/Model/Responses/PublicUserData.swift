//
//  PublicUserData.swift
//  OnTheMap
//
//  Created by Oleh Titov on 05.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation

struct PublicUserData : Codable {
    let lastName : String
    let firstName : String
    
    enum CodingKeys : String, CodingKey{
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
