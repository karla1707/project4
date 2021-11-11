//
//  LocationManager.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 07.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import MapKit

/*
 The location manager takes care of the gps signal retrieval
 it is used in the MapViewRetriever 
 */

class LocationManager:NSObject, ObservableObject{
    
    public let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate{
    
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        //print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{
            return
        }
        
        self.location = location
    }
}
