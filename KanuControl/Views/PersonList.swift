import SwiftUI

struct PersonList: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    
    /// The persons in the list
    var persons: [Person]
    
    var body: some View {
        List {
            ForEach(persons) { person in
                NavigationLink(destination: editionView(for: person)) {
                    PersonRow(person: person)
                        // Don't animate person update
                        .animation(nil, value: person)
                }
            }
            .onDelete { offsets in
                let personIds = offsets.compactMap { persons[$0].id }
                try? appDatabase.deletePerson(ids: personIds)
            }
        }
        // Animate list updates
        .animation(.default, value: persons)
        .listStyle(.plain)
    }
    
    /// The view that edits a player in the list.
    private func editionView(for person: Person) -> some View {
        PersonEditionView(person: person).navigationBarTitle(person.name)
    }
}

private struct PersonRow: View {
    var person: Person
    
    var body: some View {
        HStack {
            Text(person.nameGesamt)
            Spacer()
            Text(person.email ?? "")
                .foregroundColor(.gray)
        }
    }
}

//struct PlayerList_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            PlayerList(players: [
//                Player(id: 1, name: "Arthur", score: 100),
//                Player(id: 2, name: "Barbara", score: 1000),
//            ])
//                .navigationTitle("Preview")
//        }
//    }
//}
