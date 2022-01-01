//
//  StartMenu2.swift
//  KanuControl
//
//  Created by Christoph Schog on 30.12.21.
//

import SwiftUI

#if os(macOS)
extension View {
    func navigationBarTitle(_ title: String) -> some View {
        self
    }
}
#endif

struct StartMenu2: View {
    
    // @State private var selection: String? = nil
    @State private var showModalPersonView: Bool = false
    @State private var showModalVereinView: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            Image(uiImage: UIImage(named: "logoKanuControl100px")!)
            Text("KanuControl")
                .bold()
                .font(.largeTitle)
            Divider()
            
            HStack {
                    Button("Mitglieder") {
                        self.showModalPersonView.toggle()
                      }
                    .sheet(isPresented: $showModalPersonView) {
                        PersonView(showModal: self.$showModalPersonView)
                    }
                      .padding()
                      .frame(minWidth: 140)
                      .border(Color.black, width: 2)
                
                
                    Button("Vereine") {
                        self.showModalVereinView.toggle()
                    }
                    .sheet(isPresented: $showModalVereinView, content: {
                        VereinView(showModal: self.$showModalVereinView)
                    })
                    .padding()
                    .frame(minWidth: 140)
                    .border(Color.black, width: 2)
                }
            
            //StammdatenView()
            // Divider()
            //VeranstaltungsdatenView(selection: $selection)
            Spacer()
            Divider()
            
        }
    }
}

struct StartMenu2_Previews: PreviewProvider {
    static var previews: some View {
        StartMenu2()
    }
}
