//
// Created by Nils Bauroth on 07.04.20.
// Copyright (c) 2020 Nils Bauroth. All rights reserved.
//

import SwiftUI

struct Sellers: View {
    @ObservedObject var fetch: GenericFetchList<Seller> = GenericFetchList()
    @EnvironmentObject var loginCustomerData : LoginCustomerData


    init() {
        var requestSettings = RequestSettings()
        requestSettings.limit = 20
        fetch = GenericFetchList(requestSettings: requestSettings)
    }

    var body: some View {
        VStack {
            SellerList(fetch: fetch, title: "Sellers")
            }
        }
    }

struct Sellers_Previews: PreviewProvider {
    static var previews: some View {
        Sellers()
    }
}
