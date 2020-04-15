import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var service: Service<BoatModel>
    
    @State var showingMessage = false
    @State var message:String?
    
    var profileButtonNavigationLink: some View {
        NavigationLink(destination: UserProfileView()) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }
    
    var newModelButton: some View {
        service.currentUserAuth.map { user in
            NavigationLink(destination:
                BoatDetailView(model:
                    BoatModel(
                        id: nil,
                        title: "yack",
                        userReference: UserModel.UserReferenceModel(id: user.id )
                    )
                )
            ){
                Image(systemName: "plus.circle")
                    .imageScale(.large)
                    .accessibility(label: Text("New Model"))
                    .padding()
            }
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
                
                newModelButton
                
                Section(header: Text("models")) {
                    ForEach( service.models, id:\.id) { model in
                        NavigationLink(destination: BoatDetailView(model:model)) {
                            Text("\(model.title)")
                        }
                    }
                }
            }//end form
                .sheet(isPresented: $showingMessage) {
                Text("showing this message")
                Text("\(self.message ?? "~")?")
            }
                .navigationBarTitle( Text("Boats") )
                //.navigationBarItems( trailing: profileButtonNavigationLink)
                .navigationBarItems( leading: newModelButton , trailing: profileButtonNavigationLink  )
                .onAppear {
                    self.service.fetch()
                    
                    if self.service.currentUserAuth == nil {
                        self.message = "Login in to create a model"
                        self.showingMessage.toggle()
                    }
            }
        }
    }//end body
}//end struct

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
