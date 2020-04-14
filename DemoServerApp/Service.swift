//
//  Service.swift
//  DemoServerApp
//
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import Combine

class Service<T:GenericModel>: ObservableObject {
    
    public let objectWillChange = PassthroughSubject<Void,Never>()
    
    @Published var models:[T] = [T]() {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    func makeURL( route: String) -> URL {
        return URL(string:"http://localhost:8080/\(route)")!
    }
    
    func create(_ model: T) {
        
        guard let encodedData = try? JSONEncoder().encode(model) else {
            return
        }
        
        var request = URLRequest(url: makeURL( route: T.route) )
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                print( "model created on server \(decodedResponse)")
            } else {
                let stringified = String(decoding: data, as: UTF8.self)
                print( "error \(stringified)")
            }
            
        }.resume()
    }
    
    func fetch() {
        
        let request = URLRequest(url: makeURL( route: T.route) )
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode([T].self, from: data) {
                print( "model created on server \(decodedResponse)")
                self.models = decodedResponse
            } else {
                let stringified = String(decoding: data, as: UTF8.self)
                print( "error \(stringified)")
            }
            
        }.resume()
    }
    
}

