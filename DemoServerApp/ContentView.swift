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
    
    @EnvironmentObject var service:Service
    
    var body: some View {
        Form {
            Text("Hello, Swift Server \(service.models.count)")
            
            Button(action: {
                self.service.create(
                    TodoModel(id: nil, title: "todo_\(Int.random(in: 1...100))")
                )
            }) {
                Text("create")
            }
            
            Button(action: {
                self.service.fetch()
            }) {
                Text("fetch")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
