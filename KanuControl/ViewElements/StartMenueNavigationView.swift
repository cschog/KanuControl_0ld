//
//  StartMenueNavigationView.swift
//  KanuControl
//
//  Created by Christoph Schog on 27.12.21.
//

import SwiftUI

struct StartMenueNavigationView: View {
    
    @Binding var selection: String?
    @Binding var showModal: Bool
    
    var body: some View {
        Group {
            NavigationLink(destination: PersonView(showModal: $showModal).environment(\.appDatabase, .shared), tag: "Mitglieder", selection: $selection)
            { EmptyView() }
            
            NavigationLink(destination: VereinView().environment(\.appDatabase, .shared), tag: "Vereine", selection: $selection)
            { EmptyView() }
            
            NavigationLink(destination: Text("Veranstaltung"), tag: "Veranstaltung", selection: $selection)
            { EmptyView() }
            
            NavigationLink(destination: Text("Teilnehmer"), tag: "Teilnehmer", selection: $selection)
            { EmptyView() }
        }
    }
}
