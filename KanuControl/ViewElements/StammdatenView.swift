//
//  StammdatenView.swift
//  KanuControl
//
//  Created by Christoph Schog on 27.12.21.
//

import SwiftUI

struct StammdatenView: View {
    @Binding var selection: String?
    
    var body: some View {
        HStack {
            Button("Mitglieder") {
                self.selection = "Mitglieder"
            }
            .padding()
            .frame(minWidth: 140)
            .border(Color.black, width: 2)
        
            Button("Vereine") {
                self.selection = "Vereine"
            }
            .padding()
            .frame(minWidth: 140)
            .border(Color.black, width: 2)
        }

    }
}
