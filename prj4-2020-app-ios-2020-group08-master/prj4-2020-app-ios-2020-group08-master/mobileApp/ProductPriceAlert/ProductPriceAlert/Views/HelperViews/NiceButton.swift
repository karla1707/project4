//
//  NiceButton.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 03.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI

struct NiceButton: View {
    
    let label:String
    let logoBut: String
    let width: Int32
    let height: Int32
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action){
            HStack{
                Image(systemName: logoBut)
                    .foregroundColor(.white)
                Text(label)
                    .foregroundColor(.white)
            }
            .frame(width: CGFloat(width),height: CGFloat(height))
            .padding(.all)
            .background(Color.green)
            .cornerRadius(10.0)
            
        }
        
    }
}




