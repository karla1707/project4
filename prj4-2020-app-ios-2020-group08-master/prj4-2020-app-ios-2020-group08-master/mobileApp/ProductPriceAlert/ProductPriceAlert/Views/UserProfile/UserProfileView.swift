//
//  TestView.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 09.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    //Environmental variables which are used
    //The Register customer is used for the logout purposes
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var registerCustomerData : CustomerData
    @EnvironmentObject var editcustomerData : EditCustomerData
    
    @State var name: String = ""
    //Navigation view boolean values
    @State private var isEditPresent = false
    @State private var sellerMap = false
    @State private var isLogout = false
    
    //Load the location from the previous view
    @ObservedObject var loca : EntityFromJson<Location>
    
    
    let logoutService = LogoutService()
    //cusntructor of the view in order to preload the location
    init(loca: EntityFromJson<Location>) {
        self.loca = loca
    }
    
    
    var body: some View {
        
        return
            NavigationView{
                VStack(spacing: 2){
                    GreetingMessage(message: "Welcome to your profile: \(self.loginCustomerData.firstName)").padding(.all)
                    ZStack{
                    NavigationLink(destination: IntroView(), isActive: $isLogout){
                        Text("")
                    }
                    Button(action: {
                        print("tapped")
                        self.logoutService.logout(loginData: self.loginCustomerData, registerData: self.registerCustomerData, editData: self.editcustomerData)
                        
                        if(self.loginCustomerData.email.isEmpty){
                           print("true")
                            self.isLogout.toggle()
                        }
                    }){
                        Image(uiImage: UIImage(systemName: "trash.fill")!).resizable()
                        .scaledToFill()
                        .frame(width:20,height:20)
                        .clipShape(Circle())
                        .padding(.all)
                        Text("Logout")
                    }
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 250))
                    ImagePlaceHolder(img: self.loginCustomerData.img)
                    
                    VStack{
                        List{
                            Text("Name: \(self.loginCustomerData.firstName) \(self.loginCustomerData.lastName)")
                            Text("Email: \(self.loginCustomerData.email)")
                            Text("Address: " + loca.entity.street + " " + loca.entity.sNumber)
                            Text("Place: " + loca.entity.city + " " + loca.entity.postalCode)
                            Text("Country: " + loca.entity.country)
                        }.frame(height: UIScreen.main.bounds.width * 0.4, alignment: .center)
                        
                        HStack{
                            ZStack{
                                //Navigation link leads to the editprofile the info which is passed along with it is used to populate the forms in the next view
                                NavigationLink(destination:EditProfile(email: self.$loginCustomerData.email, password: self.$loginCustomerData.password, firstname: self.$loginCustomerData.firstName, lastname: self.$loginCustomerData.lastName, street: self.$loginCustomerData.street, sNumber: self.$loginCustomerData.sNumber, postalCode: self.$loginCustomerData.postalCode, country: self.$loginCustomerData.country, city: self.$loginCustomerData.city).environmentObject(self.loginCustomerData).environmentObject(self.editcustomerData), isActive: $isEditPresent){
                                    Text("")
                                }
                                Button(action: {
                                    //populate the rest of the logincustomer data information
                                    self.loginCustomerData.city = self.loca.entity.city
                                    self.loginCustomerData.country = self.loca.entity.country
                                    self.loginCustomerData.street = self.loca.entity.street
                                    self.loginCustomerData.postalCode = self.loca.entity.postalCode
                                    self.loginCustomerData.sNumber = self.loca.entity.sNumber
                                    self.editcustomerData.editEmail = self.loginCustomerData.email
                                    self.editcustomerData.image = UIImage(data: Data(base64Encoded: self.loginCustomerData.img)!)!
                                    //From String to Double
                                    if let lat = Double(self.loca.entity.latitude){
                                        self.loginCustomerData.lat = lat
                                    }
                                    
                                    if let long = Double(self.loca.entity.longitude){
                                        self.loginCustomerData.long = long
                                    }
                                    
                                    //move to the next
                                    self.isEditPresent.toggle()
                                }){
                                    HStack{
                                        Image(systemName: "pencil")
                                            .foregroundColor(.white)
                                        Text("Edit Profile")
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: CGFloat(140),height: CGFloat(20))
                                    .padding(.all)
                                    .background(Color.green)
                                    .cornerRadius(10.0)
                                }
                                
                            }
                            
                            ZStack{
                                //Sellers on Map
                                //TODO Incomplete atm
                                NavigationLink(destination:SellersOnMap().environmentObject(self.loginCustomerData).environmentObject(self.editcustomerData), isActive: $sellerMap){
                                    Text("")
                                }
                                Button(action: {
                                    self.sellerMap.toggle()
                                }){
                                    HStack{
                                        Image(systemName: "mappin.and.ellipse")
                                            .foregroundColor(.white)
                                        Text("Sellers")
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: CGFloat(140),height: CGFloat(20))
                                    .padding(.all)
                                    .background(Color.green)
                                    .cornerRadius(10.0)
                                }
                                
                            }
                        }.padding(.all)
                        Spacer()
                    }
                    Spacer()
                }.padding(.all)
                    .navigationBarTitle("")
                    .navigationBarBackButtonHidden(true)

                     .navigationBarHidden(true)
                    .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height-40, maxHeight: UIScreen.main.bounds.height-40,  alignment: .center)
                    .padding(.bottom)
                
        }
    }
}
