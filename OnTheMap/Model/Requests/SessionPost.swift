//
//  SessionPost.swift
//  OnTheMap
//
//  Created by Oleh Titov on 01.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation

struct SessionPost: Codable {
    let udacity : StudentCredentials
}

struct StudentCredentials: Codable {
    let username : String
    let password : String
}

