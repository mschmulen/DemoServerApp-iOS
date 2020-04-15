//
//  BoatDetailView.swift
//
//  DemoServerApp
//  Created by Matthew Schmulen on 4/14/20.
//  Copyright © 2020 jumptack. All rights reserved.
//

import SwiftUI

struct BoatDetailView: View {
    
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
                Text("SAVE")
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
    
    var footer: some View {
        Text("\(model.id?.uuidString ?? "~") ")
    }
    
    var body: some View {
        Form {
            
            TextField("title", text: $model.title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("name", text: $model.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("builder", text: $model.builder)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Toggle(isOn: $model.isFeatured){ Text("isFeatured:") }
            
            TextField("length", value: $model.length, formatter: NumberFormatter())
                .font(.body).foregroundColor(.blue)
                .padding()
                .background(Color.white)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("price", value: $model.price, formatter: currencyFormatter)
                .font(.largeTitle)
                .padding()
                .background(Color.white)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("userReference: \(model.userReference.id) ")
            
            Section {
                saveButton
                deleteButton
            }
            
            footer
            
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    public var currencyFormatter:NumberFormatter {
        get {
            let f = NumberFormatter()
            f.numberStyle = .currency
            f.usesGroupingSeparator = true
            return f
        }
    }
    
}


