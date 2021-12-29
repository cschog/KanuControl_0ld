//
//  VereinList.swift
//  KanuControl
//
//  Created by Christoph Schog on 28.12.21.
//

import SwiftUI

struct VereinList: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    
    /// The vereine in the list
    var vereine: [Verein]
    
    var body: some View {
        List {
            ForEach(vereine) { verein in
                NavigationLink(destination: editionView(for: verein)) {
                    VereinRow(verein: verein)
                        // Don't animate verein update
                        .animation(nil, value: verein)
                }
            }
            .onDelete { offsets in
                let vereinIds = offsets.compactMap { vereine[$0].id }
                try? appDatabase.deleteVerein(ids: vereinIds)
            }
        }
        // Animate list updates
        .animation(.default, value: vereine)
        .listStyle(.plain)
    }
    
    /// The view that edits a player in the list.
    private func editionView(for verein: Verein) -> some View {
        VereinEditionView(verein: verein) //.navigationBarTitle(verein.name)
    }
}

private struct VereinRow: View {
    var verein: Verein
    
    var body: some View {
        HStack {
            Text(verein.kurz ?? "")
            Spacer()
            Text(verein.name)
        }
    }
}

struct VereinList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VereinList(vereine: [
                Verein(id: nil, name: "", kurz: nil, bezirk: nil, strasse: nil, plz: nil, ort: nil, telefon: nil, homepage: nil, kz: nil, bank: nil, kontoinhaber: nil, iban: nil, bic: nil, rechtsform: nil)
            ])
                .navigationTitle("Vereine")
        }
    }
}
