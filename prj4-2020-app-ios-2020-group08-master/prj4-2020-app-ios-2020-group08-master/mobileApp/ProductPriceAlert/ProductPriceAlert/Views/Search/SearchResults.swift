//
//  SearchResultsView.swift
//  ProductPriceAlert
//
//  Created by Daniyal on 02/04/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct SearchResults: View {
    @State var userInput: String = ""
    @ObservedObject var fetch: GenericFetchList<Product>

    init() {
        var requestSettings = RequestSettings()
        requestSettings.limit = 6
        fetch = GenericFetchList(requestSettings: requestSettings)
    }
    

    var body: some View {
        VStack {
            // 1. display the search bar view and fetch the data based on the user input
            SearchBar(text: $userInput, fetch: fetch)

            // 2. display the result of fetch
            ProductList(fetch: fetch, title: "Search: \(userInput)")
        }
    }
}
