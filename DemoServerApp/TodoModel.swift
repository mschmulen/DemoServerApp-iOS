//
//  TodoModel.swift
//  DemoServerApp
//
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation


struct TodoModel: Codable {
    
    static let route = "todos"
    
    let id:UUID?
    
    let title:String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
}


