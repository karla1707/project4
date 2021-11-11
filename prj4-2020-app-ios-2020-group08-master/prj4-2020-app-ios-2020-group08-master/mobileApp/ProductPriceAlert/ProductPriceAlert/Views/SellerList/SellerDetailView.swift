//
//  SellerDetailView.swift
//  SellerList
//
//  Created by Nils Bauroth on 06.04.20.
//  Copyright © 2020 Nils Bauroth. All rights reserved.
//

import SwiftUI



struct SellerDetailView: View {
    @EnvironmentObject var loginCustomerData : LoginCustomerData

    var seller: Seller
    @ObservedObject var location: EntityFromJson<Location>

    init(seller: Seller, location: EntityFromJson<Location>) {
        self.seller = seller
        self.location = location
    }

    var body: some View {
            VStack {
                //TODO add seller coordinate
                MapView(seller: seller, location: location)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 300)
                    .padding(.bottom, 10)

                LogoImageView(seller : seller)
                    .scaleEffect(2)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, -10)
                
                VStack(alignment: .center) {
                    Text(seller.name)
                        .font(.title)

                    HStack(alignment: .top) {
                        Text("Seller Category")
                            .font(.subheadline)
                    }
                    Button(action: {
                        print("redirect to shop")
                    }) { //TODO link website, products, or whatever
                        Text("Visit website")
                        .offset(y: 50)
                    }
                }
                .padding()
                Spacer()
            }
        .navigationBarTitle(Text(seller.name), displayMode: .inline)
        }
    }

struct SellerDetail_Previews: PreviewProvider {
    static var previews: some View {
        SellerList(fetch: GenericFetchList(route: "sellers"), title: "Sellers")
    }
}
