//
//  MessageBoxView.swift
//  KanuControl
//
//  Created by Christoph Schog on 21.12.21.
//

import SwiftUI

struct MessageBoxView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var showingAlert = false

       var body: some View {
           Button("Wirklich alles löschen?") {
               showingAlert = true
           }
           .alert("Wirklich alles löschen?", isPresented: $showingAlert) {
               Button("OK", role: nil, action: { print("alles löschen")})
               Button("Cancel", role: .cancel, action: {dismiss()})
           }
       }
}

struct MessageBoxView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBoxView()
    }
}
