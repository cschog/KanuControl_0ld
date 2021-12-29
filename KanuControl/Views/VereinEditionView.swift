//
//  VereinEditionView.swift
//  KanuControl
//
//  Created by Christoph Schog on 28.12.21.
//

import SwiftUI

/// The view that edits an existing verein.
struct VereinEditionView: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    @Environment(\.isPresented) private var isPresented
    private let verein: Verein
    @State private var form: VereinForm
    
    init(verein: Verein) {
        self.verein = verein
        self.form = VereinForm(verein)
    }
    
    var body: some View {
        VereinFormView(form: $form)
            .onChange(of: isPresented) { isPresented in
                // Save when back button is pressed
                if !isPresented {
                    var savedVerein = verein
                    form.apply(to: &savedVerein)
                    // Ignore error because I don't know how to cancel the
                    // back button and present the error
                    try? appDatabase.saveVerein(&savedVerein)
                }
            }
    }
}

struct VereinEditionView_Previews: PreviewProvider {
    static var previews: some View {
        VereinEditionView(verein: Verein.init(name: ""))
        }
    }

