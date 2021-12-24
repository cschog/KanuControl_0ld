import GRDBQuery
import SwiftUI

/// The main application view
struct AppView: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    
    /// The `players` property is automatically updated when the database changes
    @Query(PersonRequest(ordering: .byName)) private var persons: [Person]
    
    /// We'll need to leave edit mode in several occasions.
    @State private var editMode = EditMode.inactive
    
    /// Tracks the presentation of the player creation sheet.
    @State private var newUserIsPresented = false
    
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            PersonList(persons: persons)
                .navigationBarTitle(Text("Mitglieder"))
                .navigationBarItems(
                    leading: HStack {
                        EditButton()
                        newPersonButton
                    }
                )
                .toolbar { toolbarContent }
                .onChange(of: persons) { persons in
                    if persons.isEmpty {
                        stopEditing()
                    }
                }
                .environment(\.editMode, $editMode)
        }.navigationViewStyle(StackNavigationViewStyle())
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

    
    private func stopEditing() {
        withAnimation {
            editMode = .inactive
        }
    }
}


struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview the default, empty database
            AppView()

        }
    }
}
