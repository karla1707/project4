//
//  AddressRegisterView.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 04.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI
import MapKit

struct AddressRegisterView: View {
    @State var street: String = ""
    @State var houseNumber: String = ""
    @State var postalCode: String = ""
    @State var city: String = ""
    @State var country: String = ""
    
    @State private var isAddresReg: Bool = false
    @State private var backButtonAddress : Bool = false
    
    @State var labelValue: String = ""
    @State var completeAddress: String = ""
    
   @EnvironmentObject var customerData : CustomerData
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var editCustomerData : EditCustomerData

    
    var body: some View {
        return
            NavigationView{
                VStack(spacing: 3){
                    Button(action: {
                        self.customerData.reset();
                        self.backButtonAddress.toggle()
                    })
                    {
                        Text("<Back")
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 270))
                    GeneralFields(fieldValue: $street,placeholder: "Street").padding(.horizontal)
                    GeneralFields(fieldValue: $houseNumber,placeholder: "House Number").padding(.horizontal)
                    GeneralFields(fieldValue: $postalCode,placeholder: "Postal Code").padding(.horizontal)
                    GeneralFields(fieldValue: $city,placeholder: "City").padding(.horizontal)
                    GeneralFields(fieldValue: $country,placeholder: "Country").padding(.horizontal)
                    
                    
                    
                    NavigationLink(destination: RegisterView(email: self.$customerData.email, firstname: self.$customerData.firstName, lastname: self.$customerData.lastName, password: self.$customerData.password).environmentObject(self.loginCustomerData).environmentObject(editCustomerData).environmentObject(customerData), isActive: $backButtonAddress){
                        Text("")
                    }
                    
                    ZStack{
                        NavigationLink(destination:CustomerLocationMapView().environmentObject(self.loginCustomerData).environmentObject(editCustomerData).environmentObject(customerData), isActive: $isAddresReg){
                            Text("")
                        }
                        Button(action: {
                            //Checks the values of the textfields
                            if(!self.street.TextFieldValidation(self.street)){
                                self.labelValue = "Not a valid street name"
                            }else if (!self.houseNumber.TextWithNumbersOnly(self.houseNumber)){
                                self.labelValue = "Not a valid street number"
                            }else if (!self.postalCode.TextWithNumbersOnly(self.postalCode)){
                                self.labelValue = "Postal code"
                            }else if (!self.city.TextFieldValidation(self.city)){
                                self.labelValue = "Not a valid city name"
                            }else if (!self.city.TextFieldValidation(self.country)){
                                self.labelValue = "Not a valid country name"
                            }else{
                                
                                //Store the data which is gonna be persisted later
                                self.customerData.sNumber = self.houseNumber
                                self.customerData.street = self.street
                                self.customerData.city = self.city
                                self.customerData.country = self.country
                                self.customerData.postalCode = self.postalCode
                                
                                //set the text as empty as no errors where reported
                                self.labelValue = ""
                                
                                self.isAddresReg.toggle()
                            }
                        }){
                            HStack{
                                Image(systemName: "map.fill")
                                    .foregroundColor(.white)
                                Text("Map Location")
                                    .foregroundColor(.white)
                            }
                            .frame(width: CGFloat(140),height: CGFloat(30))
                            .padding(.all)
                            .background(Color.green)
                            .cornerRadius(10.0)
                        }
                        
                    }
                }
                Text(self.labelValue).foregroundColor(.red).padding(.bottom)
                Spacer()
                Spacer()
                
            }.navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height-30, maxHeight: UIScreen.main.bounds.height-30,  alignment: .center)
                .padding(.bottom, 20)
        
    }
}




struct AddressRegisterView_Previews: PreviewProvider {
    @EnvironmentObject static var loginCustomerData : LoginCustomerData

    static var previews: some View {
        AddressRegisterView().environmentObject(self.loginCustomerData)
    }
}
