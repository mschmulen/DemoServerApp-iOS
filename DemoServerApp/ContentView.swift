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
    
    var newModelButton: some View {
        NavigationLink(destination: ModelDetailView(model:BoatModel(id: nil, title: "new"))) {
            Image(systemName: "plus.circle")
                .imageScale(.large)
                .accessibility(label: Text("New Model"))
                .padding()
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Button(action: {
                    self.service.fetch()
                }) {
                    Text("refresh")
                }
                
                Section(header: Text("models")) {
                    ForEach( service.models, id:\.id) { model in
                        NavigationLink(destination: ModelDetailView(model:model)) {
                            Text("\(model.title)")
                        }
                    }
                }
            }//end form
                .navigationBarTitle( Text("Boats") )
                .navigationBarItems( leading: profileButtonNavigationLink, trailing: newModelButton  )
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
