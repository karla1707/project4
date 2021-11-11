//
//  SearchBarView.swift
//  ProductPriceAlert
//
//  Created by Daniyal on 02/04/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var fetch: GenericFetchList<Product>

    func makeCoordinator() -> SearchBar.Coordinator {
        SearchBar.Coordinator.init(parentViewClass: self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchbar = UISearchBar(frame: .zero)
        searchbar.delegate = context.coordinator
        return searchbar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }

    public class Coordinator: NSObject, UISearchBarDelegate, ObservableObject {
        var parentView: SearchBar!

        init(parentViewClass: SearchBar) {
            self.parentView = parentViewClass
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        }

        // When the search button is pressed, fetch the data from the rest server
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()

            if let query = searchBar.text {
                parentView.text = query
                parentView.fetch.requestSettings.where = ["name" : WhereOptions(ilike: "%\(query)%")]
                parentView.fetch.requestSettings.offset = 0
                parentView.fetch.reload()
            }
        }
    }
}
