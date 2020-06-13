//
//  GetStudentLocationResponse.swift
//  OnTheMap
//
//  Created by Oleh Titov on 02.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation

struct GetStudentLocation: Codable {
    let results: [StudentInformation]
}
