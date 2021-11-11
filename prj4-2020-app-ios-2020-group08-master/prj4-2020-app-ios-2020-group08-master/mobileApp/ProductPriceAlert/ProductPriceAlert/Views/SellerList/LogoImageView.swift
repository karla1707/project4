//
//  LogoImageView.swift
//  SellerList
//
//  Created by Nils Bauroth on 07.04.20.
//  Copyright © 2020 Nils Bauroth. All rights reserved.
//

import SwiftUI

struct LogoImageView: View {

    var seller: Seller

    var body: some View {
        //AsyncImage(
        //    url: URL(string : seller.logo)!
        //, placeholder: Text("Loading"))
        //    .aspectRatio(contentMode: .fit)
        //   .frame(width: 50, height: 50)
        Image(uiImage: loadImage(base64String: seller.logo))
        .resizable()
        .scaledToFit()
        .frame(width: 50.0)
    }
}

struct Image_Previews: PreviewProvider {
    static var previews: some View {
        SellerList(fetch: GenericFetchList(route: "sellers"), title: "Sellers")
    }
}
