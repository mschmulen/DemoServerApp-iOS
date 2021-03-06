//
//  BoatModel.swift
//  DemoServerApp
//
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation

protocol GenericModel: Codable {
    static var route: String { get }
    var id:UUID? { get }
}

struct BoatModel: GenericModel {
    
    static let route = "boats"
    
    let id:UUID?
    
    var title:String = ""
    
    var name:String = ""
    
    var length: Float = 0

    var builder: String = ""
    
    var price: Double = 0.0
    
    var isFeatured: Bool = false
    
    var userReference: UserModel.UserReferenceModel
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case length
        case builder
        case price
        case isFeatured
        case userReference
    }
    
}


