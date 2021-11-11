//
//  MapView.swift
//  SellerList
//
//  Created by Nils Bauroth on 06.04.20.
//  Copyright © 2020 Nils Bauroth. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var loginCustomerData : LoginCustomerData

    var seller: Seller
    @ObservedObject var location: EntityFromJson<Location>
    let annotation = MKPointAnnotation()

    init(seller: Seller, location: EntityFromJson<Location>) {
        self.seller = seller
        self.location = location
    }

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {

        var lat = location.entity.latitude.toDouble() ?? 0.0
        var long = location.entity.longitude.toDouble() ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        annotation.coordinate = coordinate

        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)

        annotation.title = seller.name
        annotation.subtitle =   location.entity.street + " " + location.entity.sNumber + "\n" +
                                location.entity.postalCode + " " + location.entity.city + "\n" +
                                location.entity.country
        uiView.addAnnotation(annotation)
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        SellerList(fetch: GenericFetchList(route: "sellers"), title: "Sellers")
    }
}
