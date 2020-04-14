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

extension UserModel {
    
    public struct UserSignUpRequest: Codable {
        public var email:String
        public var password:String
    }

    public struct UserSignInRequest: Codable {
        public var email: String
        public var password: String
    }

    public struct UserAuthResponse: Codable {
        public var email: String
        public var reason:String
        public var id: UUID?
        public var sessionToken: String?
    }
    
    public struct UserSignOutRequest: Codable {
        public var email:String
        public var password:String
    }
    
    public struct UserSignOutResponse: Codable {
        public var id:UUID
        public var email:String
    }
    
}
