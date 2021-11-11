//
//  DropDownView.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 16.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI

struct DropDown: View {
    
    @State var expand = false
    @State var chosenValue: String
    
    var body: some View {
        VStack() {
            Spacer()
            VStack(spacing: 30) {
                HStack() {
                    Text("Menu")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Image(systemName: expand ? "chevron.up" : "chevron.down")
                        .resizable()
                        .frame(width: 13, height: 6)
                        .foregroundColor(.white)
                }.onTapGesture {
                    self.expand.toggle()
                }
                if expand {
                    Button(action: {
                        self.chosenValue = "blue"
                        self.expand.toggle()
                    }) {
                        Text("Blue")
                            .padding(10)
                    }.foregroundColor(.white)
                    Button(action: {
                        self.chosenValue = "pink"

                        self.expand.toggle()
                    }) {
                        Text("Pink")
                            .padding(10)
                    }.foregroundColor(.white)
                    Button(action: {
                        self.chosenValue = "black"
                        self.expand.toggle()
                    }) {
                        Text("Black")
                            .padding(10)
                    }.foregroundColor(.white)
                    
                    Button(action: {
                        self.chosenValue = "green"
                        self.expand.toggle()
                    }) {
                        Text("Green")
                            .padding(10)
                    }.foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.green)
            .cornerRadius(15)
            .shadow(color: .gray, radius: 5)
            .animation(.spring())
        }
    }
}

