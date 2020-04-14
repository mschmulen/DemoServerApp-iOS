//
//  UserModel.swift
//  DemoServerApp
//
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

struct UserModel: GenericModel {
    
    static let route = "users"
    
    let id:UUID?
    
    var email:String
    
    var password:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case password
    }
    
}

