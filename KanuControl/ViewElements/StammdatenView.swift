//
//  StammdatenView.swift
//  KanuControl
//
//  Created by Christoph Schog on 27.12.21.
//

import SwiftUI

struct StammdatenView: View {
    //@Binding var selection: String?
    @State var showLoginView: Bool = false
    
    var body: some View {
        HStack {
                Button("Mitglieder") {
                      self.showLoginView = true
                  }
                  .padding()
                  .frame(minWidth: 140)
                  .border(Color.black, width: 2)
            
                Button("Vereine") {
                    self.showLoginView = true
                }
                .padding()
                .frame(minWidth: 140)
                .border(Color.black, width: 2)
            }
            
       }

    }
