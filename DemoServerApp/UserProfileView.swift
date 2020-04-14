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

        }
    }
    
}
