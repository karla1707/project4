//
//  ProductView.swift
//  ProductPriceAlert
//
//  Created by Karla on 02/04/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct ProductView: View {
    
    var product: Product
    @State private var buyAlert = false
    @ObservedObject var seller : EntityFromJson<Seller>
    @EnvironmentObject var loginCustomerData : LoginCustomerData


    init(product: Product, seller: EntityFromJson<Seller>){
        self.seller = seller
        self.product = product
    }

    init (product: Product) {
        let entityLoader = EntityFromJson(entity: Seller(id: 0, name: "", locationId: 1, logo: ""), id: String(product.sellerId))
        self.init(product: product, seller: entityLoader)
    }

    var body: some View {

        var ShowImage: Image?
        if let data = Data(base64Encoded: product.image) {
            if let image = UIImage(data: data) {
                ShowImage = Image(uiImage: image)
            }
        }
        
      return   VStack(alignment: .leading, spacing: 0) {

            
        ShowImage
            
            Spacer()
            
            Text(product.name).font(.title)
            Spacer()
                            
    
            HStack {
             
                
                Text(seller.entity.name)

                
                Text(product.categoryName)
                .padding(10)
                
                
            }

                    
            Text(product.description)
           
            Text(String(product.price))

            Spacer()
            .frame(height: 40)
            
            
            HStack{
                
                NavigationLink(destination: CreatePriceAlert(product: product)) {
                    Text("Add alert")
                }.padding(.leading,70)

            
                Spacer()
                
                Button(action: {
                          
                    self.buyAlert = true
                      }) {
                          Text("Buy")
                      }
                      .alert(isPresented: $buyAlert) {
                          SwiftUI.Alert(title: Text("You bought the product!"), message: Text(""), dismissButton: .default(Text("OK")))
                      }
                  }.padding(.trailing,70)
            
        
        
        Spacer()
        .frame(height: 40)
            
        }
        .padding(10)
           .navigationBarTitle("", displayMode: .inline)

        .onAppear(){
            
            ProductService.updateNumberOfViews(product: self.product)
         
        }
        
    }
    
  
  
}




    




