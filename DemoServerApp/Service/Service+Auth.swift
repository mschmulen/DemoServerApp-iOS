//
//  Service+Authentication.swift
//  DemoServerApp
//
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import Foundation
import Combine

// MARK: - Authentication Services
extension Service {
    
    public func signIn(
        email: String,
        password: String,
        handler: @escaping (Result<UserModel.UserAuthResponse, Error>) -> Void
    ) {
        
        if email.isEmpty || password.isEmpty {
            return handler(.failure(ServiceError.invalidData))
        }
        let signInRequest = UserModel.UserSignInRequest(email: email.lowercased(), password: password)
        
        guard let encodedData = try? JSONEncoder().encode(signInRequest) else {
            handler(.failure(ServiceError.encodeError))
            return
        }
        
        let url = makeURL(route: "signin")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedData
        
        URLSession.shared.dataTask(with: request) { (data, request, error) in
            
            guard let data = data else {
                if let error = error {
                    handler(.failure(ServiceError.networkFailure(error)))
                } else {
                    handler(.failure(ServiceError.unknownError))
                }
                return
            }
            
            if let encodedModel = try? JSONDecoder().decode(UserModel.UserAuthResponse.self, from:data) {
                if let sessionToken = encodedModel.sessionToken {
                    self.currentUserAuth = encodedModel
                    self.updateUserDefaults( data: AppUserDefaultData(
                        userID: encodedModel.id.uuidString,
                        userEmail: encodedModel.email,
                        userPassword: password,
                        sessionToken: sessionToken
                    ))
                    handler(.success(encodedModel))
                } else {
                    print( "reason \(encodedModel.reason)")
                    handler(.failure(ServiceError.unknownError))
                }
            } else {
                let stringData = String(decoding: data, as: UTF8.self)
                handler(.failure( ServiceError.decodeError(stringData)))
                return
            }
        }.resume()
    }
    
    public func signUp(
        email: String,
        password: String,
        handler: @escaping (Result<UserModel.UserAuthResponse, Error>) -> Void
    ) {
        if email.isEmpty || password.isEmpty {
            return
                handler(.failure(ServiceError.invalidData))
        }
        
        let signUpRequest = UserModel.UserSignUpRequest(email: email.lowercased(), password: password)
        
        guard let encodedData = try? JSONEncoder().encode(signUpRequest) else {
            handler(.failure(ServiceError.encodeError))
            return
        }
        
        let url = makeURL(route: "signup")
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encodedData
        
        URLSession.shared.dataTask(with: request) { (data, request, error) in
            
            guard let data = data else {
                if let error = error {
                    handler(.failure(ServiceError.networkFailure(error)))
                } else {
                    handler(.failure(ServiceError.unknownError))
                }
                return
            }
            
            if let encodedModel = try? JSONDecoder().decode(UserModel.UserAuthResponse.self, from:data) {
                if let sessionToken = encodedModel.sessionToken {
                    self.currentUserAuth = encodedModel
                    self.updateUserDefaults( data: AppUserDefaultData(
                        userID: encodedModel.id.uuidString,
                        userEmail: encodedModel.email,
                        userPassword: password,
                        sessionToken: sessionToken
                    ))
                    handler(.success(encodedModel))
                } else {
                    handler(.failure(ServiceError.unknownError))
                }
            } else {
                let stringData = String(decoding: data, as: UTF8.self)
                handler(.failure( ServiceError.decodeError(stringData)))
                return
            }
        }.resume()
    }
    
    public func signOut(_ completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        currentUserAuth = nil
        clearUserDefaults()
        completionHandler(.success(true))
    }
    
    public func attemptAutoSignIn( _ completionHandler: @escaping (Result<String, Error>) -> Void) {
        if let data = self.fetchUserDefaults() {
            self.signIn(email: data.userEmail, password: data.userPassword) { result in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(let model):
                    completionHandler(.success(model.email))
                }
            }
        }
    }
}


// MARK: - Local UserDefaultsPersistance
extension Service {
    
    private struct AppUserDefaultData {
        let userID:String
        let userEmail:String
        let userPassword:String
        let sessionToken:String
    }
    
    private func updateUserDefaults( data: AppUserDefaultData ) {
        let defaults = UserDefaults.standard
        defaults.set(data.userID, forKey: "userID")
        defaults.set(data.userEmail, forKey: "userEmail")
        defaults.set(data.userPassword, forKey: "userPassword")
        defaults.set(data.sessionToken, forKey: "sessionToken")
    }
    
    private func fetchUserDefaults() -> AppUserDefaultData? {
        let defaults = UserDefaults.standard
        guard let userID = defaults.string(forKey: "userID"),
            let userEmail = defaults.string(forKey: "userEmail"),
            let userPassword = defaults.string(forKey: "userPassword"),
            let sessionToken = defaults.string(forKey: "sessionToken") else {
                return nil
        }
        return AppUserDefaultData(
            userID: userID,
            userEmail: userEmail,
            userPassword: userPassword,
            sessionToken: sessionToken
        )
    }
    
    private func clearUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "userID")
        defaults.set(nil, forKey: "userEmail")
        defaults.set(nil, forKey: "userPassword")
        defaults.set(nil, forKey: "sessionToken")
    }
    
}
