//
//  FilterProducts.swift
//  G8ProductPriceAlert
//
//  Created by Karla on 23/04/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI
import Combine


struct FilterProducts: View {
  
    @ObservedObject var fetch: GenericFetchList<Product>
    @ObservedObject var category: GenericFetchList<Category>
    @State var selections: [String] = []
    @State private var minPrice = "0"
    @State private var maxPrice = "0"


    
    init(fetch: GenericFetchList<Product>) {
        self.fetch = fetch;
        self.category = GenericFetchList(route: "categories")

        
       }

    var body: some View {
    
        

      return  VStack{
            Spacer()
                .frame(height: 50)
            
            Text("Select category: ")
           
            List {
                
                ForEach(self.category.list, id: \.self) { item in
            MultipleSelectionRow(title: item.self.name, isSelected: self.selections.contains(item.name)) {
                if self.selections.contains(item.name) {
                    self.selections.removeAll(where: { $0 == item.name })
                          }
                          else {
                    self.selections.append(item.name)
                          }
                      }
                  }

        }
            Spacer().frame(height: 100)
           
            
            HStack {
               
                Text("Price range: ").padding()
                


                TextField("", text: $minPrice)
                .keyboardType(.numberPad)
                .onReceive(Just(minPrice)) { newValue in
                               let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.minPrice = filtered
                    }
                    }.fixedSize()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                  
            Text(" - ")
                               
            TextField("", text: $maxPrice)
                               .keyboardType(.numberPad)
                               .onReceive(Just(maxPrice)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                   if filtered != newValue {
                                       self.maxPrice = filtered
                               }
                           }.fixedSize()
                           .textFieldStyle(RoundedBorderTextFieldStyle())



          }
            Spacer().frame(height: 50)

        Button(action: {
            FilterLogic(min: self.minPrice, max: self.maxPrice, cat: self.selections, fetch: self.fetch)
        }
            
        ) {
            Text("Confirm")
        }
        

             NavigationLink(destination: ProductList(fetch: fetch, title: "filtered")) {
                 Text("go")
             }
        
    }
    }
   
}


struct MultipleSelectionRow: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

