//
//  ContentView.swift
//  DemoServerApp
//
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var service: Service<BoatModel>
    
    var profileButtonNavigationLink: some View {
        NavigationLink(destination: UserProfileView()) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Text("Hello, Swift Server \(service.models.count)")
                
                Button(action: {
                    self.service.create(
                        BoatModel(id: nil, title: "boat_\(Int.random(in: 1...100))")
                    )
                    self.service.fetch()
                }) {
                    Text("create")
                }
                
                Button(action: {
                    self.service.fetch()
                }) {
                    Text("fetch")
                }
                
                ForEach( service.models, id:\.id) { model in
                    NavigationLink(destination: ModelDetailView(model:model)) {
                        Text("\(model.title)")
                    }
                }
            }//end form
                .navigationBarTitle( Text("Boats") )
                .navigationBarItems( trailing: profileButtonNavigationLink )
                .onAppear {
                    self.service.fetch()
            }
            
        }
    }//end body
}//end struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
