//
//  SellersOnMap.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 10.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

/*
 INCoMPLETE for now
 */

import SwiftUI

struct SellersOnMap: View {
    @State var sellersOnMap : Bool = true
    @EnvironmentObject var loginCustomerData : LoginCustomerData

    var mapView = MapViewRetriever()
    @ObservedObject private var locationManager = LocationManager()


    var body: some View {
        return VStack{
            GreetingMessage(message: "The red pins on the map are the sellers you have registered")
            mapView
            
            Spacer()
        }
    }
}

struct SellersOnMap_Previews: PreviewProvider {
    static var previews: some View {
        SellersOnMap()
    }
}
