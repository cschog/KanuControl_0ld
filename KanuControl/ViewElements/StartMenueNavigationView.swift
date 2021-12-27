//
//  StartMenueNavigationView.swift
//  KanuControl
//
//  Created by Christoph Schog on 27.12.21.
//

import SwiftUI

struct StartMenueNavigationView: View {
    
    @Binding var selection: String?
    
    var body: some View {
        Group {
            NavigationLink(destination: AppView().environment(\.appDatabase, .shared), tag: "Mitglieder", selection: $selection)
            { EmptyView() }
            
            NavigationLink(destination: Text("Vereine"), tag: "Vereine", selection: $selection)
            { EmptyView() }
            
            NavigationLink(destination: Text("Veranstaltung"), tag: "Veranstaltung", selection: $selection)
            { EmptyView() }
            
            NavigationLink(destination: Text("Teilnehmer"), tag: "Teilnehmer", selection: $selection)
            { EmptyView() }
        }
    }
}
