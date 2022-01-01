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
    
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Vereine")
                    .bold()
                    .font(.largeTitle)
                VereinList(vereine: vereine)
                             //.navigationBarTitle(Text("Vereine"))
                             .navigationBarItems(
                                 leading: HStack {
                                     dismissViewButton
                                     EditButton()
                                     newVereinButton
                                 }
                             )
                            // .toolbar { toolbarContent }  // Möglichkeit alle Vereine zu löschen
                             .onChange(of: vereine) { vereine in
                                 if vereine.isEmpty {
                                     stopEditing()
                                 }
                             }
                             .environment(\.editMode, $editMode)
                     }.navigationViewStyle(StackNavigationViewStyle())
            }
         
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
    
    /// Button to dismiss the view
    private var dismissViewButton: some View {
        
        Button("Zurück") {
            self.showModal.toggle()
        }
    }

    
    private func stopEditing() {
        withAnimation {
            editMode = .inactive
        }
    }
}


//struct VereinView_Previews: PreviewProvider {
//    @Binding var showModal: Bool
//
//    static var previews: some View {
//        Group {
//            // Preview the default, empty database
//            VereinView(showModal: $showModul)
//
//        }
//    }
//}

