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
    
    @Published var currentUserAuth:UserModel.UserAuthResponse? {
        didSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
}

extension Service {
    
    enum ServiceError: Error {
        case requestFailed
        case invalidData
        case encodedError
        case encodeError
        case networkFailure( Error )
        case unknownError
        case decodeError( String )
    }
    
    func makeURL( route: String, pagination: PaginatedRequest? = nil) -> URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "localhost"
        components.port = 8080
        components.path = "/\(route)"
        let url = components.url!
        return url
    }
    
}

extension Service {
    
    func create(
        _ model: T,
        handler: @escaping (Result<T, Error>) -> Void
    ) {
        guard let encodedData = try? JSONEncoder().encode(model) else {
            handler(.failure( ServiceError.encodeError))
            return
        }
        
        var request = URLRequest(url: makeURL( route: T.route) )
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                handler(.failure( ServiceError.encodeError))
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                handler( .success(decodedResponse))
            } else {
                let stringified = String(decoding: data, as: UTF8.self)
                handler(.failure( ServiceError.decodeError( stringified )))
            }
            
        }.resume()
    }
    
    public func fetch() {
        let pagination:PaginatedRequest? = PaginatedRequest(page: 1, per: 10)
        fetchModels(pagination: pagination) { result in
            switch result {
            case .success( let data ) :
                self.models = data.items
            case .failure( let error ):
                print( "error \(error)")
            }
        }
    }
    
}

extension Service {

    /// update
    public func update(
        _ model: T,
        handler: @escaping (Result<T,Error>)->Void
    ) {
        
        guard let id = model.id else {
            handler(.failure( ServiceError.invalidData))
            return
        }
        
        guard let encodedData = try? JSONEncoder().encode(model) else {
            handler(.failure( ServiceError.invalidData))
            return
        }
        
        let extendedURL = makeURL(route: T.route).appendingPathComponent("/\(id)")
        var request = URLRequest(url: extendedURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = encodedData
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                return handler( .failure(ServiceError.requestFailed))
            }
            
            if let decodedResponse = try? JSONDecoder().decode(T.self, from: data) {
                print( "\(decodedResponse)")
                handler( .success(decodedResponse))
            } else {
                let stringResponse = String( decoding: data, as: UTF8.self )
                handler(.failure( ServiceError.decodeError(stringResponse)))
            }
        }.resume()
    }
    
    
    /// delete
    public func delete(
        _ model: T,
        callback: @escaping (Result<T,Error>)->Void
    ) {
        
        guard let id = model.id else {
            callback(.failure( ServiceError.invalidData))
            return
        }
        
        let extendedURL = makeURL(route: T.route).appendingPathComponent("/\(id)")
        var request = URLRequest(url: extendedURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse  {
                if response.statusCode == 200 {
                    callback( .success(model))
                } else {
                    callback(.failure( ServiceError.requestFailed))
                }
            } else {
                callback(.failure( ServiceError.requestFailed))
            }
        }.resume()
    }

    /// fetchModels
    private func fetchModels(
        pagination: PaginatedRequest?,
        callback: @escaping (Result<PagedResponse<T>,Error>)->Void
    ) {
        
        let request = URLRequest(url: self.makeURL(route: T.route, pagination: pagination))
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                callback(.failure( ServiceError.unknownError))
                return
            }
            
            if let pagedResponseModel = try? JSONDecoder.init().decode(PagedResponse<T>.self, from: data) {
                callback( .success(pagedResponseModel))
            } else {
                let dataString = String(decoding: data, as: UTF8.self)
                callback(.failure( ServiceError.decodeError(dataString)))
            }
        }.resume()
    }
}
