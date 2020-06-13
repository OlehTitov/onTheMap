//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Oleh Titov on 01.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable, Error {
    let status: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
           case status
           case message = "error"
       }
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}
