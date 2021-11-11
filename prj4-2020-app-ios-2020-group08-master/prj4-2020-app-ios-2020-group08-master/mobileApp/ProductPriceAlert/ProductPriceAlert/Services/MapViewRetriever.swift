//
//  MapView.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 07.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

/*
 Integration of MapKit in Swiftui
 */

struct MapViewRetriever: UIViewRepresentable {
    /*
    @State var showSellers : Bool = true
    @State var email: String = ""
    @ObservedObject var fetch = GenericFetchList<Product>()
    
    
    init(showSellers: Bool, email: String) {
        self.showSellers = showSellers
        self.email = email
    }
    */
    class Coordinator: NSObject,MKMapViewDelegate{
        
        var parent: MapViewRetriever
        
        init(_ parent: MapViewRetriever) {
            self.parent = parent
        }
        //show the location in the map
        //show desired pins on the map
        func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]){
            if let annotationView = views.first{
                if let annotation = annotationView.annotation {
                    if annotation is MKUserLocation {
                        
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        mapView.setRegion(region, animated: true)
                    }
                }
            }
            
            
            
            //Example Annotation Add annotation for every place around u based on seller
            let annot = MKPointAnnotation()
            annot.coordinate = CLLocationCoordinate2D(latitude: 51.464568, longitude: 6.655836)
            annot.title = "La Luna"
            annot.subtitle = "Best Pizza Ever"
            mapView.addAnnotation(annot)
        }
        
        /*
         func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
         print(mapView.centerCoordinate.latitude)
         print(mapView.centerCoordinate.longitude)
         mapView.showsUserLocation = true
         }
         
         func mapView(_ mapView:MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView?{
         let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
         view.canShowCallout = true
         return view
         }
         
         func getLongitude(_ mapView:MKMapView)->Double{
         return mapView.centerCoordinate.longitude
         }
         
         func getLatitude(_ mapView:MKMapView)->Double{
         return mapView.centerCoordinate.latitude
         }
         */
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
   
   
    
}


