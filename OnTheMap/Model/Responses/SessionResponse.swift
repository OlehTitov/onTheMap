//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by Oleh Titov on 01.06.2020.
//  Copyright © 2020 Oleh Titov. All rights reserved.
//

import Foundation

struct SessionResponse: Decodable {
    let account: UdacityAccount
    let session: UdacitySession
    //let status: Int?
    //let error: String?
}

struct UdacityAccount: Decodable {
    let registered: Bool
    let key: String
}

struct UdacitySession: Decodable {
    let id: String
    let expiration: String
}

/*
 Sample response
{
    "account":{
        "registered":true,
        "key":"3903878747"
    },
    "session":{
        "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
        "expiration":"2015-05-10T16:48:30.760460Z"
    }
}
*/
