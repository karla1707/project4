//
//  ImagePlaceHolder.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 18.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI


struct ImagePlaceHolder: View {
    
    @State var img : String
    
    var body: some View {
        Image(uiImage: UIImage(data: Data(base64Encoded: self.img)!)!) .resizable()
        .scaledToFill()
        .frame(width:150,height:150)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.green,lineWidth: 10))
        .padding(.all)
    }
    
}
