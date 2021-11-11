//
// Created by Nils Bauroth on 07.04.20.
// Copyright (c) 2020 Nils Bauroth. All rights reserved.
//

import SwiftUI

struct SellerList: View {
    @ObservedObject var fetch : GenericFetchList<Seller>
    @EnvironmentObject var loginCustomerData : LoginCustomerData

    var title : String

    init(fetch: GenericFetchList<Seller>, title : String) {
        self.fetch = fetch
        self.title = title
    }

    var body: some View {
        NavigationView {
            VStack {
                List(fetch.list) { s in
                    NavigationLink(destination: SellerDetailView(seller: s, location:
                    EntityFromJson<Location>(entity: Location(id: Int(), street: "", postalCode: "", sNumber: "", city: "", country: "", longitude: "", latitude: ""), id: String(s.locationId)))) {
                        SellerRow(seller: s)
                                .onAppear(perform: {
                                    self.fetch.loadMore(s)
                                })
                    }
                }
                        .navigationBarTitle(title)
            }
        }
    }
}

struct SellerList_Previews: PreviewProvider {
    static var previews: some View {
        SellerList(fetch: GenericFetchList(route: "sellers"), title: "Sellers")
    }
}
