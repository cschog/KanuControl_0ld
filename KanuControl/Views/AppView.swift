import GRDBQuery
import SwiftUI

/// The main application view
struct AppView: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    
    /// The `players` property is automatically updated when the database changes
    @Query(PersonRequest(ordering: .byAgeUp)) private var persons: [Person]
    
    /// We'll need to leave edit mode in several occasions.
    @State private var editMode = EditMode.inactive
    
    /// Tracks the presentation of the player creation sheet.
    @State private var newUserIsPresented = false
    
    // If you want to define the query on initialization, you will prefer:
    //
    // @Query<PlayerRequest> private var players: [Player]
    //
    // init(initialOrdering: PlayerRequest.Ordering) {
    //     _players = Query(PlayerRequest(ordering: initialOrdering))
    // }
    
    var body: some View {
        NavigationView {
            PersonList(persons: persons)
                .navigationBarTitle(Text("Mitglieder"))
                .navigationBarItems(
                    leading: HStack {
                        EditButton()
                        newPersonButton
                    },
                    trailing: ToggleOrderingButton(
                        ordering: $persons.ordering,
                        willChange: {
                            // onChange(of: $players.wrappedValue.ordering)
                            // is not able to leave the editing mode during
                            // the animation of the list content.
                            // Workaround: stop editing before the ordering
                            // is changed, and the list content is updated.
                            stopEditing()
                        }))
                .toolbar { toolbarContent }
                .onChange(of: persons) { persons in
                    if persons.isEmpty {
                        stopEditing()
                    }
                }
                .environment(\.editMode, $editMode)
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button {
                // Don't stopEditing() here because this is
                // performed `onChange(of: players)`
                try! appDatabase.deleteAllPersons()
            } label: {
                Image(systemName: "trash").imageScale(.large)
            }
            
            Spacer()
            
            Button {
                stopEditing()
                try! appDatabase.refreshPersons()
            } label: {
                Image(systemName: "arrow.clockwise").imageScale(.large)
            }
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

private struct ToggleOrderingButton: View {
    @Binding var ordering: PersonRequest.Ordering
    let willChange: () -> Void
    
    var body: some View {
        switch ordering {
        case .byAgeDown:
            Button {
                willChange()
                ordering = .byAgeDown
            } label: {
                Label("Alter", systemImage: "arrowtriangle.down.fill").labelStyle(.titleAndIcon)
            }
        case .byAgeUp:
            Button {
                willChange()
                ordering = .byAgeUp
            } label: {
                Label("Alter", systemImage: "arrowtriangle.up.fill").labelStyle(.titleAndIcon)
            }
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
