//
//  VereinView.swift
//  KanuControl
//
//  Created by Christoph Schog on 28.12.21.
//

import GRDBQuery
import SwiftUI

/// The Verein view
struct VereinView: View {
    /// Write access to the database
    @Environment(\.appDatabase) private var appDatabase
    
    /// The `Verein` property is automatically updated when the database changes
    @Query(VereinRequest(ordering: .byName)) private var vereine: [Verein]
    
    /// We'll need to leave edit mode in several occasions.
    @State private var editMode = EditMode.inactive
    
    /// Tracks the presentation of the player creation sheet.
    @State private var newVereinIsPresented = false
    
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            VereinList(vereine: vereine)
                //.navigationBarTitle(Text("Vereine"))
                .navigationBarItems(
                    leading: HStack {
                        EditButton()
                        newVereinButton
                    }
                )
                .toolbar { toolbarContent }
                .onChange(of: vereine) { vereine in
                    if vereine.isEmpty {
                        stopEditing()
                    }
                }
                .environment(\.editMode, $editMode)
        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle("Vereine")
    }
    
    private var toolbarContent: some ToolbarContent {
       
        ToolbarItemGroup(placement: .bottomBar) {

            Button {
                // Don't stopEditing() here because this is
                // performed `onChange(of: vereine)`
                showingAlert.toggle()
            } label: {
                Image(systemName: "trash").imageScale(.large)
            }
            .alert("Wirklich alles löschen?", isPresented: $showingAlert) {
                Button("OK", role: nil, action: {try! appDatabase.deleteAllVereine()})
                Button("Cancel", role: .cancel, action: {})}
            
            Spacer()
        }
    }
    
    /// The button that presents the verein creation sheet.
    private var newVereinButton: some View {
        Button {
            stopEditing()
            newVereinIsPresented = true
        } label: {
            Image(systemName: "plus")
        }
        .accessibility(label: Text("Neuer Verein"))
        .sheet(isPresented: $newVereinIsPresented) {
            VereinCreationView()
        }
    }

    
    private func stopEditing() {
        withAnimation {
            editMode = .inactive
        }
    }
}


struct VereinView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview the default, empty database
            VereinView()

        }
    }
}

