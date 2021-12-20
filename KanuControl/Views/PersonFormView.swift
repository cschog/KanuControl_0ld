import SwiftUI

/// The Person editing form, embedded in both
/// `PersonCreationView` and `PersonEditionView`.
struct PersonFormView: View {
    @Binding var form: PersonForm
    
    var body: some View {
        List {
            Group {
                TextField("Name", text: $form.name)
                    .accessibility(label: Text("Person Name"))
                TextField("Vorname", text: $form.vorname)
                    .accessibility(label: Text("Vorname"))
                TextField("Geburtstag", text: $form.geburtstag)
                    .accessibility(label: Text("Geburtstag"))
                    .keyboardType(.numbersAndPunctuation)
                TextField("Geschlecht", text: $form.sex)
                    .accessibility(label: Text("Geschlecht"))
                    .keyboardType(.alphabet)
                TextField("Strasse", text: $form.strasse)
                    .accessibility(label: Text("Strasse"))
                TextField("PLZ", text: $form.plz)
                    .accessibility(label: Text("PLZ"))
                TextField("Ort", text: $form.ort)
                    .accessibility(label: Text("Ort"))
            }
            Group {
                TextField("Telefon Festnetzt", text: $form.telefonFestnetz)
                    .keyboardType(.phonePad)
                    .accessibility(label: Text("Telefon Festnetz"))
                TextField("Telefon Mobil", text: $form.telefonMobil)
                    .accessibility(label: Text("Telefon Mobil"))
                    .keyboardType(.phonePad)
                TextField("email", text: $form.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .accessibility(label: Text("email"))
                TextField("Bankname", text: $form.bank)
                    .accessibility(label: Text("Bank"))
                TextField("IBAN", text: $form.iban)
                    .accessibility(label: Text("IBAN"))
                TextField("BIC", text: $form.bic)
                    .accessibility(label: Text("BIC"))
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct PersonForm {
    var name: String
    var vorname: String
    var geburtstag: String
    var sex: String
    var strasse: String
    var plz: String
    var ort: String
    var telefonFestnetz: String
    var telefonMobil: String
    var email: String
    var namegesamt: String
    var status: Bool
    var statusDatum: String
    var bank: String
    var iban: String
    var bic: String
}

extension PersonForm {
    init(_ person: Person) {
        self.name = person.name
        self.vorname = person.vorname
        self.geburtstag = person.geburtstag ?? ""
        self.sex = person.sex ?? ""
        self.strasse = person.strasse ?? ""
        self.plz = person.plz ?? ""
        self.ort = person.ort ?? ""
        self.telefonFestnetz = person.telefonFestnetz ?? ""
        self.telefonMobil = person.telefonMobil ?? ""
        self.email = person.email ?? ""
        self.namegesamt = person.nameGesamt
        self.status = person.status
        self.statusDatum = person.statusDatum
        self.bank = person.bank ?? ""
        self.iban = person.iban ?? ""
        self.bic = person.bic ?? ""
    }
    
    func apply(to person: inout Person) {
        person.name = name
        person.vorname = vorname
        person.geburtstag = geburtstag
        person.sex = sex
        person.strasse = strasse
        person.plz = plz
        person.ort = ort
        person.telefonFestnetz = telefonFestnetz
        person.telefonMobil = telefonMobil
        person.email = email
        person.nameGesamt = namegesamt
        person.status = status
        person.statusDatum = statusDatum
        person.bank = bank
        person.iban = iban
        person.bic = bic
    }
}

//struct PersonFormView_Previews: PreviewProvider {
//    let person = Person(from: Decoder as! Decoder)
//    static var previews: some View {
//        Group {
//            PersonFormView(form: .constant(PersonForm(person)))
//        }
//    }
//}
