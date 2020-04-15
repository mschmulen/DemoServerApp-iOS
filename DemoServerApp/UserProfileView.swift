//
//  UserProfileView.swift
//  DemoServerApp
//
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    
    @EnvironmentObject var service: Service<BoatModel>
    
    var body: some View {
        Form {
            Text("UserProfile")
            
            Text("email: \(service.currentUserAuth?.email ?? "~")")
            Text("id: \(service.currentUserAuth?.id.uuidString ?? "~")")
            Text("sessionToken: \(service.currentUserAuth?.sessionToken ?? "~")")
            
            Button(action: {
                self.service.signUp(email: "matt.schmulen@gmail.com", password:"password") { result in
                    switch result {
                    case .success( let data ):
                        print( "success \(data)")
                    case .failure( let error ):
                        print( "error \(error)")
                    }
                }
            }) {
                Text("sign-up")
            }.disabled((service.currentUserAuth != nil))
            
            Button(action: {
                self.service.signIn(email: "matt.schmulen@gmail.com", password:"password") { result in
                    switch result {
                    case .success( let data ):
                        print( "success \(data)")
                    case .failure( let error ):
                        print( "error \(error)")
                    }
                }
            }) {
                Text("sign-in")
            }.disabled((service.currentUserAuth != nil))
            
            Button(action: {
                self.service.signOut() { result in
                    switch result {
                    case .success( let data ):
                        print( "success \(data)")
                    case .failure( let error ):
                        print( "error \(error)")
                    }
                }
            }) {
                Text("sign-out")
            }.disabled((service.currentUserAuth == nil))
        }
    }
    
}
