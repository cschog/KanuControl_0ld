import SwiftUI

/// The view that edits an existing player.
struct PersonEditionView: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    @Environment(\.isPresented) private var isPresented
    private let person: Person
    @State private var form: PersonForm
    
    init(person: Person) {
        self.person = person
        self.form = PersonForm(person)
    }
    
    var body: some View {
        PersonFormView(form: $form)
            .onChange(of: isPresented) { isPresented in
                // Save when back button is pressed
                if !isPresented {
                    var savedPerson = person
                    form.apply(to: &savedPerson)
                    // Ignore error because I don't know how to cancel the
                    // back button and present the error
                    try? appDatabase.savePerson(&savedPerson)
                }
            }
    }
}

struct PersonEditionView_Previews: PreviewProvider {
    static var previews: some View {
        PersonEditionView(person: Person.init(name: "", vorname: "", nameGesamt: "", statusDatum: ""))
        }
    }
