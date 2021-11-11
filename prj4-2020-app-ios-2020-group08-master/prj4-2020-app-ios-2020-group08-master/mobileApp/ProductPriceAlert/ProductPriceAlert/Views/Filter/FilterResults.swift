//
//  FilterResults.swift
//  G8ProductPriceAlert
//
//  Created by Karla on 06/05/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct FilterResults: View {
    
    @ObservedObject var fetch: GenericFetchList<Product>

    init(fetch: GenericFetchList<Product>){
        self.fetch = fetch
    }
    var body: some View {
       
        ProductList(fetch: fetch, title: "Filtered")
        
    }
}


