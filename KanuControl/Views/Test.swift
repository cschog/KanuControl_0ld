//
//  Test.swift
//  KanuControl
//
//  Created by Christoph Schog on 31.12.21.
//

import SwiftUI

struct Test: View{
    @State var value = ""
    var placeholder = "Select Client"
    var dropDownList = ["PSO", "PFA", "AIR", "HOT",
                        "PSO2", "PFA", "AIR", "HOT",
                        "PSO3", "PFA", "AIR", "HOT",
                        "PSO4", "PFA", "AIR", "HOT",
                        "PSO5", "PFA", "AIR", "HOT5"]
    var body: some View {
        ScrollView {
            Menu {
                ForEach(dropDownList.sorted(), id: \.self){ client in
                    Button(client) {
                        self.value = client
                    }
                }
            } label: {
                VStack(spacing: 5){
                    HStack{
                        Text(value.isEmpty ? placeholder : value)
                            .foregroundColor(value.isEmpty ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color.orange)
                            .font(Font.system(size: 20, weight: .bold))
                    }
                    .padding(.horizontal)
                    Divider()
    //                Rectangle()
    //                    .fill(Color.orange)
    //                    .frame(height: 2)
                }
            }
        }

    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
