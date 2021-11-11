//
//  CoordinateRetriever.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 10.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import CoreLocation
/**
 uses the core location package to popylate the two doubles
 using the string address it fetches the location coordinates from the two attributes
 */

class CoordinatorRetriever: ObservableObject {
    
    var latitude: Double?
    var longitude: Double?
    var address:String?
    
    init(address: String) {
        self.address = address
        getLocation(address: address)
    }
    
    func setAddress(address: String){
        self.address = address
        getLocation(address: address)
    }
    
    func getLocation(address: String) {

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            let coordinate = placemark.location?.coordinate
            self.latitude = coordinate?.latitude
            self.longitude = coordinate?.longitude
        }
    }
    
}
