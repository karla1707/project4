//
//  ProductList.swift
//  ProductPriceAlert
//
//  Created by Paul Severin on 02.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct ProductList: View {
    @ObservedObject var fetch : GenericFetchList<Product>
    @EnvironmentObject var loginCustomerData : LoginCustomerData

    var title : String

    init(fetch: GenericFetchList<Product>, title : String) {
        self.fetch = fetch
        self.title = title
    }

    var body: some View {
     
        NavigationView() {
      

            VStack {
              
                List(fetch.list) { p in
                    NavigationLink(destination: ProductView(product: p)) {
                        ProductRow(product: p)
                        // pass product to fetch object when user scrolled to it so fetch logic can determine if more data needs to be loaded (inifinite scrolling)
                        .onAppear(perform: {
                            self.fetch.loadMore(p)
                        })
                    }
                }
                   
                .navigationBarTitle(title)
            
            }
        }
    }
}

struct ProductList_Previews: PreviewProvider {
    static var previews: some View {
        ProductList(fetch: GenericFetchList(route : "products"), title: "Products")
    }
}
