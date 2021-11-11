//
//  TabBarView.swift
//  ProductPriceAlert
//
//  Created by Karla on 09/04/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var selection = 3
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var editCustomerData : EditCustomerData
    @EnvironmentObject var registerCustomerData : CustomerData

    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.black
        
    }
    
    var body: some View {
        
        TabView {
            
            
            PopularProducts()
                .tabItem (
                    {
                        VStack {
                            Image(systemName: "heart")
                            Text("Popular ")
                        }
                }).tag(0)
            
            Sellers()
                .tabItem (
                    {
                        VStack {
                            Image(systemName: "heart")
                            Text("Seller")
                        }
                }).tag(0)
            
            // TODO change
            SearchResults()
                .tabItem(
                    {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                        
                }).tag(1)
            
            if(self.loginCustomerData.email.isEmpty) {
                IntroView().environmentObject(self.loginCustomerData)
                    .tabItem(
                        {
                            VStack {
                                Image(systemName: "person")
                                Text("Login")
                            }
                            
                    }).tag(1)
                
            } else {
                UserProfileView(loca: EntityFromJson<Location>(entity: Location(id: 0, street: "", postalCode: "", sNumber: "", city: "", country: "", longitude: "", latitude: ""), id: String(self.loginCustomerData.locId))).environmentObject(self.loginCustomerData)
                .tabItem(
                    {
                        VStack {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                        
                }).tag(1)
                
            }
            
            
        } .accentColor(.green)
            .padding(.bottom)
            .shadow(radius: 1)
    }
    
}


struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
