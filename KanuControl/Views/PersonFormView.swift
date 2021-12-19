import SwiftUI

/// The User editing form, embedded in both
/// `UserCreationView` and `UserEditionView`.
struct PersonFormView: View {
    @Binding var form: PersonForm
    
    var body: some View {
        List {
            TextField("Name", text: $form.name)
                .accessibility(label: Text("Person Name"))
            TextField("email", text: $form.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .accessibility(label: Text("email"))
            TextField("age", text: $form.age)
                .keyboardType(.numberPad)
                .accessibility(label: Text("Person Age"))
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct PersonForm {
    var name: String
    var email: String
    var age: String
}

extension PersonForm {
    init(_ person: Person) {
        self.name = person.name
        self.email = person.email
        self.age = "\(person.age)"
    }
    
    func apply(to person: inout Person) {
        person.name = name
        person.email = email
        person.age = Int(age) ?? 0
    }
}

struct PersonFormView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PersonFormView(form: .constant(PersonForm(
                name: "",
                email: "",
                age: "")))
        }
    }
}
