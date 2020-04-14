//
//  Service.swift
//  DemoServerApp
//
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import Combine

class Service: ObservableObject {
    
    public let objectWillChange = PassthroughSubject<Void,Never>()
    
    @Published var models:[TodoModel] = [TodoModel]() {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    func create(_ model:TodoModel) {
        
        guard let encodedData = try? JSONEncoder().encode(model) else {
            return
        }
        
        var request = URLRequest(url: URL(string:"http://localhost:8080/\(TodoModel.route)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(TodoModel.self, from: data) {
                print( "model created on server \(decodedResponse)")
            } else {
                let stringified = String(decoding: data, as: UTF8.self)
                print( "error \(stringified)")
            }
            
        }.resume()
    }
    
    func fetch() {
        
        var request = URLRequest(url: URL(string:"http://localhost:8080/\(TodoModel.route)")!)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode([TodoModel].self, from: data) {
                print( "model created on server \(decodedResponse)")
                self.models = decodedResponse
            } else {
                let stringified = String(decoding: data, as: UTF8.self)
                print( "error \(stringified)")
            }
            
        }.resume()
    }
    
}

