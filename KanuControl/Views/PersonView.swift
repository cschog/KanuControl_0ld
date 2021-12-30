import GRDBQuery
import SwiftUI

/// The main application view
struct PersonView: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    
    @Environment(\.presentationMode) var presentationMode
    
    /// The `Person` property is automatically updated when the database changes
    @Query(PersonRequest(ordering: .byName)) private var persons: [Person]
    
    /// We'll need to leave edit mode in several occasions.
    @State private var editMode = EditMode.inactive
    
    /// Tracks the presentation of the player creation sheet.
    @State private var newUserIsPresented = false
    
    @State private var showingAlert = false
    
    @State private var isShowSheet: Bool = false
    
    @Binding var showModal: Bool

    var body: some View {
        NavigationView {
            VStack{
                Text("Mitglieder")
                    .bold()
                    .font(.largeTitle)
                PersonList(persons: persons)
                    //.navigationBarTitle(Text("Mitglieder"))
                    .navigationBarItems(
                        leading: HStack {
                            dismissViewButton
                            EditButton()
                            newPersonButton
                            Spacer()
                            
                        }
                    )
                    .toolbar { toolbarContent }
                    .onChange(of: persons) { persons in
                        if persons.isEmpty {
                            stopEditing()
                        }
                    }
                    .environment(\.editMode, $editMode)
            }

        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle("Mitglieder")
    }
    
    private var toolbarContent: some ToolbarContent {
       
        ToolbarItemGroup(placement: .bottomBar) {

            Button {
                // Don't stopEditing() here because this is
                // performed `onChange(of: players)`
                showingAlert.toggle()
            } label: {
                Image(systemName: "trash").imageScale(.large)
            }
            .alert("Wirklich alles löschen?", isPresented: $showingAlert) {
                Button("OK", role: nil, action: {try! appDatabase.deleteAllPersons()})
                Button("Cancel", role: .cancel, action: {})}
            
            Spacer()
        }
    }
    
    /// The button that presents the person creation sheet.
    private var newPersonButton: some View {
        Button {
            stopEditing()
            newUserIsPresented = true
        } label: {
            Image(systemName: "plus")
        }
        .accessibility(label: Text("Neues Mitglied"))
        .sheet(isPresented: $newUserIsPresented) {
            PersonCreationView()
        }
    }
    
    /// Button to dismiss the view
    private var dismissViewButton: some View {
        
        Button("Zurück") {
            self.showModal.toggle()
        }
    }

    
    private func stopEditing() {
        withAnimation {
            editMode = .inactive
        }
    }
}


//struct PersonView_Previews: PreviewProvider {
//    @Binding var showModal: Bool
//    
//    static var previews: some View {
//        Group {
//            // Preview the default, empty database
//            PersonView(showModal: $showModal)
//
//        }
//    }
//}
