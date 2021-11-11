//
//  ProductList.swift
//  ProductPriceAlert
//
//  Created by Paul Severin on 02.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct PopularProducts: View {
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var editCustomerData : EditCustomerData
    @ObservedObject var fetch: GenericFetchList<Product>
    
    init(fetch: GenericFetchList<Product>){
        self.fetch = fetch
    }

    init() {
        var requestSettings = RequestSettings()
        requestSettings.order = ["numberOfViews DESC"]
        requestSettings.limit = 20
        fetch = GenericFetchList(requestSettings: requestSettings)

    }
    var body: some View {
            
        NavigationView {
           
            VStack(alignment: .leading, spacing: 0){
                
                NavigationLink(destination: FilterProducts(fetch: fetch)) {
                    Text("Filter")
                    
                }
                
                ProductList(fetch: fetch, title: "Popular Products")
                
               
            }
           
            
        }
}
        
}
struct PopularProducts_Previews: PreviewProvider {
    static var previews: some View {
        PopularProducts()
    }
}
