//
//  ModelDetailView.swift
//
//  DemoServerApp
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct ModelDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var service: Service<BoatModel>
    
    @State var model:BoatModel
    
    var saveButton: some View {
        if model.id != nil {
            return Button(action: {
                self.service.update(self.model) { result in
                    switch result {
                    case .success( _):
                        self.dismiss()
                    case .failure(let error):
                        print( "error \(error)")
                    }
                }
            }) {
                Text("UPDATE")
            }.disabled((model.id == nil))

        } else {
            return Button(action: {
                self.service.create(self.model) { result in
                    switch result {
                    case .success( _):
                        self.dismiss()
                    case .failure(let error):
                        print( "error \(error)")
                    }
                }
            }) {
                Text("ADD")
            }.disabled((model.id != nil))
        }
    }
    
    var deleteButton: some View {
        Button(action: {
            self.service.delete(self.model) { result in
                switch result {
                case .success( _):
                    self.dismiss()
                case .failure(let error):
                    print( "error \(error)")
                }
            }
        }) {
            Text("DELETE")
        }.disabled((model.id == nil))
    }
    
    var header: some View {
        Text("\(model.id?.uuidString ?? "~") ")
    }

    
    var body: some View {
        Form {
            
            header
            
            TextField("title", text: $model.title)
            TextField("name", text: $model.name)
            Text("length: \(model.length) ")
            
            saveButton
            deleteButton
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}


