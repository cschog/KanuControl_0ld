import SwiftUI

/// The view that creates a new player.
struct PersonCreationView: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    @Environment(\.dismiss) private var dismiss
    @State private var form = PersonForm(name: "", email: "", age: "")
    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""
    
    var body: some View {
        NavigationView {
            PersonFormView(form: $form)
                .alert(
                    isPresented: $errorAlertIsPresented,
                    content: { Alert(title: Text(errorAlertTitle)) })
                .navigationBarTitle("Neues Mitglied")
                .navigationBarItems(
                    leading: Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Abbruch")
                    },
                    trailing: Button {
                        save()
                    } label: {
                        Text("Speichern")
                    })
        }
    }
    
    private func save() {
        do {
            var person = Person(id: nil, name: "", email: "", age: 0)
            form.apply(to: &person)
            try appDatabase.savePerson(&person)
            dismiss()
        } catch {
            errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
            errorAlertIsPresented = true
        }
    }
}

struct PlayerCreationSheet_Previews: PreviewProvider {
    static var previews: some View {
        PersonCreationView()
    }
}
