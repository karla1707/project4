//
//  ProductRow.swift
//  ProductPriceAlert
//
//  Created by Paul Severin on 02.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI
import Foundation

struct ProductRow: View {
    
    var product : Product
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    
    var body: some View {
        HStack {
            Image(uiImage: loadImage(base64String: product.image))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100.0)
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                    .frame(alignment: .leading)
                Text(product.description)
//                Text("\(product.numberOfViews)")
            }
            .padding()

        }
        .frame(height: 100)
    }
}
