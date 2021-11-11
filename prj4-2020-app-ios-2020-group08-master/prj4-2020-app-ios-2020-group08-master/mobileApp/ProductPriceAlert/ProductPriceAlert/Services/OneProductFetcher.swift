//
//  ProductViewFromNotification.swift
//  G8ProductPriceAlert
//
//  Created by Daniyal on 18/05/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct OneProductFetcher: View {
    
    @ObservedObject var productFetch : EntityFromJson<Product>
    
    var product = Product(id: 0,
                          name: "",
                          description: "",
                          image: "",
                          price: 0,
                          sellerId: 0,
                          categoryName: "",
                          numberOfViews: 0)

    init(pId: String){
        self.productFetch = EntityFromJson(entity: product, id: pId)
    }

    var body: some View {
        VStack {
            ProductView(product: productFetch.entity)
        }
    }
}
