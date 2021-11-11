//
//  NiceTextFields.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 03.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI

struct GeneralFields : View {
    @Binding var fieldValue: String
    let placeholder: String
    var body: some View {
        return TextField(placeholder, text: $fieldValue)
            .foregroundColor(.white)
            .padding(.all)
            .background(Color.init(UIColor.lightGray))
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}



struct BorderlessFields : View {
    @Binding var fieldValue: String
    let placeholder: String
    var body: some View {
        return TextField(placeholder, text: $fieldValue)
            .foregroundColor(.black)
            .padding(.all)
            .background(Color.init(UIColor.white))
            .cornerRadius(5.0)
            .border(Color.white,width:0)
    }
}

struct PasswordTextFieldNoBorder : View {
    @Binding var password: String
    
    var body: some View {
        return SecureField("Password", text: $password)
            .foregroundColor(.white)
            .padding(.all)
            .background(Color.init(UIColor.lightGray))
            .cornerRadius(5.0)
        .border(Color.white,width:0)
    }
}


struct PasswordTextField : View {
    @Binding var password: String
    
    var body: some View {
        return SecureField("Password", text: $password)
            .foregroundColor(.white)
            .padding(.all)
            .background(Color.init(UIColor.lightGray))
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
