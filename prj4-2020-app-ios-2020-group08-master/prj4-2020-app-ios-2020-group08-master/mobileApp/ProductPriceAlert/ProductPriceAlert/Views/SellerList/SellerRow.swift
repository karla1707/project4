//
// Created by Nils Bauroth on 07.04.20.
// Copyright (c) 2020 Nils Bauroth. All rights reserved.
//

import SwiftUI
import Foundation

struct SellerRow: View {
    @EnvironmentObject var loginCustomerData : LoginCustomerData

    var seller : Seller

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading) {
                HStack(spacing: 10) {
                    LogoImageView(seller : seller)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(seller.name).font(.system(size: 20)).bold()
                        Text("Seller Category")
                    }
                }
            }
                .padding(.leading, 15)
                .padding(.trailing, 15)
        }
            .padding(.top, 5)

        }
    }


struct SellerRow_Previews: PreviewProvider {
    static var previews: some View {
        SellerList(fetch: GenericFetchList(route: "sellers"), title: "Sellers")
    }
}
