//
//  ModelDetailView.swift
//
//  DemoServerApp
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ModelDetailView: View {
    
    var model:BoatModel
    
    var body: some View {
        Form {
            Text("model.title: \(model.title) ")
            Text("model.id: \(model.id?.uuidString ?? "~") ")
            Text("length: \(model.length) ")
            Text("name: \(model.name) ")
        }
    }
    
}


