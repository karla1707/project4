//
//  ContentView.swift
//  ProductPriceAlert
//
//  Created by Daniyal on 31/03/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI
import CoreLocation



struct IntroView: View {
    
    @EnvironmentObject var customerData : CustomerData
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var editCustomerData : EditCustomerData

    
    @State private var presentLogin = false
    @State private var presentRegister = false
    @State var tester = false
    @State var labelValue = ""
    
    @State var locid = 0
    
    
    var body: some View {
        return NavigationView{
            VStack{
                //Image with logo company
                Image("alert_price").resizable().aspectRatio(contentMode: .fit).frame(width:200,height: 200)
                HStack{
                    //Login Button with Navigation link
                    ZStack{
                        NavigationLink(destination: LoginView().environmentObject(self.loginCustomerData).environmentObject(self.editCustomerData).environmentObject(self.customerData), isActive: $presentLogin){
                            Text("")
                        }
                        Button(action: {
                            //if the email has not been set then the user is already logged in and not allowed to try and login again
                            if(self.loginCustomerData.email.isEmpty){
                                self.presentLogin.toggle()
                            }else{
                                self.labelValue = "You are already logged in"
                            }
                            
                        }){
                            HStack{
                                Image(systemName: "person.circle")
                                    .foregroundColor(.white)
                                Text("Login")
                                    .foregroundColor(.white)
                            }
                            .frame(width: CGFloat(140),height: CGFloat(30))
                            .padding(.all)
                            .background(Color.green)
                            .cornerRadius(10.0)
                        }
                        
                    }
                    
                    //Register Button part
                    ZStack{
                        NavigationLink(destination:RegisterView(email: self.$customerData.email, firstname: self.$customerData.firstName, lastname: self.$customerData.lastName, password: self.$customerData.password).environmentObject(self.loginCustomerData).environmentObject(self.editCustomerData).environmentObject(self.customerData), isActive: $presentRegister){
                            Text("")
                        }
                        Button(action: {
                            //if the email has not been set then the user is already logged in and not allowed to try and login again
                            if(self.loginCustomerData.email.isEmpty){
                                self.presentRegister.toggle()
                            }else{
                                self.labelValue = "You have already an account"
                            }                        }){
                                HStack{
                                    Image(systemName: "pencil")
                                        .foregroundColor(.white)
                                    Text("Register")
                                        .foregroundColor(.white)
                                }
                                .frame(width: CGFloat(140),height: CGFloat(30))
                                .padding(.all)
                                .background(Color.green)
                                .cornerRadius(10.0)
                        }
                        
                    }
                }
                
                Text(self.labelValue).foregroundColor(.red)
            }
        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height, maxHeight: UIScreen.main.bounds.height)
        
        
    }
}

