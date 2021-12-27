//
//  VeranstaltungsdatenView.swift
//  KanuControl
//
//  Created by Christoph Schog on 27.12.21.
//

import SwiftUI

struct VeranstaltungsdatenView: View {
    
    @Binding var selection: String?
    
    var body: some View {
        HStack {
               Button("Veranstaltung") {
                   self.selection = "Veranstaltung"
               }
               .padding()
               .frame(minWidth: 140)
               .border(Color.black, width: 2)
               
               Button("Teilnehmer") {
                   self.selection = "Teilnehmer"
               }
               .padding()
               .frame(minWidth: 140)
               .border(Color.black, width: 2)
           }
    }
}
