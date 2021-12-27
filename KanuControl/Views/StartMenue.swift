//
//  StartMenue.swift
//  KanuControl
//
//  Created by Christoph Schog on 25.12.21.
//

import SwiftUI

#if os(macOS)
extension View {
    func navigationBarTitle(_ title: String) -> some View {
        self
    }
}
#endif
    


struct StartMenue: View {
    @State private var selection: String? = nil
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                // Navigationlinks
                StartMenueNavigationView(selection: $selection)
                
                // Stammdaten Mitglieder und Vereine
                StammdatenView(selection: $selection)

                Divider()
                
                // Veranstaltungsdaten: Veranstaltungen und Teilnehmer
                VeranstaltungsdatenView(selection: $selection)
                
                Spacer()
            }
                .navigationTitle("KanuControl")
        }
    }
}

struct StartMenue_Previews: PreviewProvider {
    static var previews: some View {
        StartMenue()
    }
}


