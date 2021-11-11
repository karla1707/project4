//
//  RegisterView.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 03.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    //Bindings which are use to store the values from the texfield
    @Binding var email: String
    @Binding var firstname: String
    @Binding var lastname: String
    @Binding var password: String
    
    @State private var isPresentRegister: Bool = false
    @State private var backButton : Bool = false
    
    @State var labelValue : String = ""
    //environmental variables used here
    @EnvironmentObject var customerData : CustomerData
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var editCustomerData : EditCustomerData
    
    var body: some View {
        var customerWithEmail = ListWithFiler<Customer>(name: "email", value:self.email)
        
        return
            NavigationView{
                    
                    VStack(spacing: 3) {
                        
                        Button(action: {
                            self.customerData.reset();
                            self.backButton = true
                        })
                        {
                            Text("<Back")
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 270))
                                                
                        GreetingMessage(message: "Please fill in the form!")
                        GeneralFields(fieldValue: $firstname,placeholder: "Name...").padding(.horizontal)
                        GeneralFields(fieldValue: $lastname,placeholder: "Lastname...").padding(.horizontal)
                        GeneralFields(fieldValue: $email,placeholder: "Email...").padding(.horizontal)
                        PasswordTextField(password: $password).padding(.horizontal)
                        
                        //Register Button part
                        HStack{
                            NavigationLink(destination:IntroView().environmentObject(self.loginCustomerData).environmentObject(self.customerData).environmentObject(self.editCustomerData), isActive: $backButton){
                                Text("")
                            }
                            ZStack{
                                NavigationLink(destination:AddressRegisterView().environmentObject(self.loginCustomerData).environmentObject(self.customerData).environmentObject(self.editCustomerData), isActive: $isPresentRegister){
                                    Text("")
                                }
                                Button(action: {
                                    //Basic imput checks
                                    if(!self.email.EmailFieldValidation(self.email)){
                                        self.labelValue = "Not a valid email"
                                    }else if (!self.password.PasswordValidation(self.password)){
                                        self.labelValue = "The password needs two uppercase letters, one special case letter, one digit"
                                    }else if (self.password.count < 8){
                                        self.labelValue = "The password needs to be at least 8 characters"
                                    }else if (!self.firstname.TextFieldValidation(self.firstname)){
                                        self.labelValue = "Not a valid name it needs to contain at least 2 letters"
                                    }else if (!self.lastname.TextFieldValidation(self.lastname)){
                                        self.labelValue = "Not a valid lastname it needs to contain at least 2 letters"
                                    }else if (!customerWithEmail.list.isEmpty){
                                        self.labelValue = "This email already exists"
                                    }else{
                                        //save the customer which is gonna be persisted later
                                        self.customerData.firstName = self.firstname
                                        self.customerData.lastName = self.lastname
                                        self.customerData.email = self.email
                                        self.customerData.password = self.password
                                        self.labelValue = ""
                                        
                                        //toggle the bool and take the user to the next
                                        self.isPresentRegister.toggle()
                                    }
                                }){
                                    HStack{
                                        Image(systemName: "envelope")
                                            .foregroundColor(.white)
                                        Text("Address")
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: CGFloat(140),height: CGFloat(30))
                                    .padding(.all)
                                    .background(Color.green)
                                    .cornerRadius(10.0)
                                }
                                
                            }
                        }
                        Text(self.labelValue).foregroundColor(.red).padding(.all)
                    }.onAppear{
                        customerWithEmail.listFetch(name: "email", value:self.email)
                    }
                
            }.navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height-20, maxHeight: UIScreen.main.bounds.height-20,  alignment: .center)
                .padding(.bottom)
                .onAppear{
                    self.backButton = false
        }
        
    }
}


struct GreetingMessage: View {
    let message: String
    var body: some View {
        Text(message)
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.bottom, 10)
    }
}
