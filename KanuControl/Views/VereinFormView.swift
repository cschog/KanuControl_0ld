//
//  VereinFormView.swift
//  KanuControl
//
//  Created by Christoph Schog on 28.12.21.
//

import SwiftUI

/// The Verein editing form, embedded in both
/// VereinCreationView` and `VereinEditionView`.
struct VereinFormView: View {
    @Binding var form: VereinForm
    
    var body: some View {
        List {
            Group {
                HStack {
                    TextField("Abkürzung", text: $form.kurz)
                        .accessibility(label: Text("Abkürzung"))
                    TextField("Vereinskennzeichen", text: $form.kz)
                        .accessibility(label: Text("Vereinskennzeichen"))
                    }
                TextField("Vereinsname", text: $form.name)
                    .accessibility(label: Text("Vereinsname"))
                TextField("Bezirk", text: $form.bezirk)
                    .accessibility(label: Text("Bezrk"))
                TextField("Strasse", text: $form.strasse)
                    .accessibility(label: Text("Strasse"))
                HStack {
                    TextField("PLZ", text: $form.plz)
                        .accessibility(label: Text("PLZ"))
                    TextField("Ort", text: $form.ort)
                        .accessibility(label: Text("Ort"))
                    }
                }
            Group {
                TextField("Telefon", text: $form.telefon)
                    .keyboardType(.phonePad)
                    .accessibility(label: Text("Telefon"))
                TextField("Homepage", text: $form.homepage)
                    .accessibility(label: Text("Homepage"))
                    .keyboardType(.webSearch)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                TextField("bank", text: $form.bank)
                    .accessibility(label: Text("Bank"))
                TextField("Kontoinhaber", text: $form.kontoinhaber)
                    .accessibility(label: Text("Kontoinhaber"))
                TextField("IBAN", text: $form.iban)
                    .accessibility(label: Text("IBAN"))
                TextField("BIC", text: $form.bic)
                    .accessibility(label: Text("BIC"))
                TextField("Rechtsform", text: $form.rechtsform)
                    .accessibility(label: Text("Rechtsform"))
            }
        }
        //.listStyle(InsetGroupedListStyle())
    }
}

struct VereinForm {
    var name: String
    var kurz: String
    var bezirk: String
    var strasse: String
    var plz: String
    var ort: String
    var telefon: String
    var homepage: String
    var kz: String
    var bank: String
    var kontoinhaber: String
    var iban: String
    var bic: String
    var rechtsform: String
}

extension VereinForm {
    init(_ verein: Verein) {
        self.name = verein.name
        self.kurz = verein.kurz ?? ""
        self.bezirk = verein.bezirk ?? ""
        self.strasse = verein.strasse ?? ""
        self.plz = verein.plz ?? ""
        self.ort = verein.ort ?? ""
        self.telefon = verein.telefon ?? ""
        self.homepage = verein.homepage ?? ""
        self.kz = verein.kz ?? ""
        self.bank = verein.bank ?? ""
        self.kontoinhaber = verein.kontoinhaber ?? ""
        self.iban = verein.iban ?? ""
        self.bic = verein.bic ?? ""
        self.rechtsform = verein.rechtsform ?? ""
    }
    
    func apply(to verein: inout Verein) {
        verein.name = name
        verein.kurz = kurz
        verein.bezirk = bezirk
        verein.strasse = strasse
        verein.plz = plz
        verein.ort = ort
        verein.telefon = telefon
        verein.homepage = homepage
        verein.kz = kz
        verein.bank = bank
        verein.kontoinhaber = kontoinhaber
        verein.iban = iban
        verein.bic = bic
        verein.rechtsform = rechtsform

    }
}

struct VereinFormView_Previews: PreviewProvider {
    
    static var previews: some View {
        VereinFormView(form: .constant(VereinForm(name: "", kurz: "", bezirk: "", strasse: "", plz: "", ort: "", telefon: "", homepage: "", kz: "", bank: "", kontoinhaber: "", iban: "", bic: "", rechtsform: "")))
        
    }
}

