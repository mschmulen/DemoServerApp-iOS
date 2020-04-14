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
    
    var title:String
    
    var name:String = ""
    
    var length: Float = 0

    var builder: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case length
        case builder
    }
    
}

public struct PaginatedRequest {
    let page:Int
    let per:Int
}

public struct PagedResponse<T:Codable>: Codable {
    
    public var items: [T]
    public var metadata: MetaData
    
    public struct MetaData: Codable {
        var per: Int
        var total: Int
        var page: Int
    }
}
