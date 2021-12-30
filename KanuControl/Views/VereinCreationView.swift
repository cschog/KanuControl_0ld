//
//  VereinCreationView.swift
//  KanuControl
//
//  Created by Christoph Schog on 28.12.21.
//

import SwiftUI

/// The view that creates a new verein.
struct VereinCreationView: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    @Environment(\.dismiss) private var dismiss
    @State private var form = VereinForm(
        name: "",
        kurz: "",
        bezirk: "",
        strasse: "",
        plz: "",
        ort: "",
        telefon: "",
        homepage: "",
        kz: "",
        bank: "",
        kontoinhaber: "",
        iban: "",
        bic: "",
        rechtsform: "")
    
    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""
    
    var body: some View {
        NavigationView {
            VereinFormView(form: $form)
                .alert(
                    isPresented: $errorAlertIsPresented,
                    content: { Alert(title: Text(errorAlertTitle)) })
                .navigationBarTitle("Neuer Verein")
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
            var verein = Verein(
                id: nil,
                name: "",
                kurz: "",
                bezirk: "",
                strasse: "",
                plz: "",
                ort: "",
                telefon: "",
                homepage: "",
                kz: "",
                bank: "",
                kontoinhaber: "",
                iban: "",
                bic: "",
                rechtsform: ""
            )
            form.apply(to: &verein)
            try appDatabase.saveVerein(&verein)
            dismiss()
        } catch {
            errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
            errorAlertIsPresented = true
        }
    }
}

struct VereinCreationSheet_Previews: PreviewProvider {
    static var previews: some View {
        VereinCreationView()
    }
}
