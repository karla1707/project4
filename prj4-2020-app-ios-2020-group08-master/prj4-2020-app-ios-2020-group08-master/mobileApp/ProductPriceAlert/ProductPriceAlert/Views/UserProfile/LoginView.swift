//
//  LoginView.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 03.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    //State variables they represent the values in the textfields, named after the purpose which they serve
    @State var email: String = ""
    @State var password: String = ""
    //is used to activate the navigation link
    @State private var isPresent: Bool = false
    @State private var goBack: Bool = false
    
    //used to represent error messages
    @State var labelValue : String = ""
    
    //Environmental variables to be populated and shared amongst views
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var editCustomerData : EditCustomerData
    
    
    var body: some View {
        //fetch the customer from the DB
        let fetcher =  EntityFromJson<Customer>(entity: Customer(firstName: "", lastName: "", email: "", locationId: 0, image: ""), id: self.email)
        
        
        return
            NavigationView{
                VStack {
                    //Text fields and
                    WelcomeMessage()
                    ZStack{
                        NavigationLink(destination: IntroView(), isActive: $goBack){
                            Text("")
                        }
                        Button(action: {
                            print("tapped")
                            self.goBack.toggle()
                            
                        }){
                            
                            Text("<Back")
                        }
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 250))
                    
                    LoginPicture(picName: "user_pic")
                    GeneralFields(fieldValue: $email,placeholder: "Email").padding(.horizontal)
                    PasswordTextField(password: $password).padding(.horizontal)
                    
                    //the user to their profile
                    ZStack{
                        NavigationLink(destination:UserProfileView(loca: EntityFromJson<Location>(entity: Location(id: 0, street: "", postalCode: "", sNumber: "", city: "", country: "", longitude: "", latitude: ""), id: String(self.loginCustomerData.locId))).environmentObject(self.loginCustomerData).environmentObject(self.editCustomerData), isActive: $isPresent){
                            Text("")
                        }
                        Button(action: {
                            
                            //Check the inputs and present a message if sth is wrong
                            if(!self.email.EmailFieldValidation(self.email)){
                                self.labelValue = "Not a valid email"
                            }else{
                                //if inputs are valid then take the entity and compare passwords
                                let postman = EntityPostMan()
                                
                                
                                let user = User(email: self.email, password: self.password)
                                
                                do{
                                    //jsonify the customer object
                                    
                                    let userData = try JSONSerialization.data(withJSONObject: postman.getEntityDictionary(entity: user), options: .init())
                                    
                                    postman.login(request: userData, resultType: User.self){
                                        (userResponse) in

                                        let delegate = UIApplication.shared.delegate as! AppDelegate
                                        print(delegate.token)

                                        self.loginCustomerData.token = userResponse.token
                                        //send device token for push notification to backend
                                        sendToken(device_token: delegate.token, access_token: userResponse.token, customerEmail: userResponse.email)

                                        let custo = fetcher.entity
                                        print(custo)
                                        //from the retrieved object save the values
                                        self.loginCustomerData.email = custo.email
                                        self.loginCustomerData.firstName = custo.firstName
                                        self.loginCustomerData.lastName = custo.lastName
                                        self.loginCustomerData.locId = custo.locationId
                                        //if the user chose not to have an image they will receive a basic image
                                        
                                        if (custo.image.count > 0){
                                            self.loginCustomerData.img = custo.image
                                            self.editCustomerData.img = custo.image
                                            
                                        }else{
                                            if let img = UIImage(systemName: "person"){
                                                self.loginCustomerData.img = postman.getStringFromImage(image: img)
                                                self.editCustomerData.img = self.loginCustomerData.img
                                            }
                                            
                                        }

                                        
                                        //Set the textfields as empty
                                        self.email = ""
                                        self.password = ""
                                        //move to the next view
                                        self.isPresent.toggle()
                                        
                                    }
                                    
                                }catch let err{
                                    //if it is not correct notify
                                    self.labelValue = "Wrong credentials"
                                    debugPrint(err.localizedDescription)
                                    
                                }
                                
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
                        Spacer()
                    }
                    //Error label
                    Text(self.labelValue).foregroundColor(.red).padding(.all)
                }.padding(.all)
            }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
                .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height-20, maxHeight: UIScreen.main.bounds.height-20,  alignment: .center)
                .padding(.bottom)
    }
}

struct LoginView_Previews: PreviewProvider {
    @EnvironmentObject static var loginCustomerData : LoginCustomerData

    static var previews: some View {
       

        LoginView().environmentObject(self.loginCustomerData)
    }
}



struct WelcomeMessage: View {
    var body: some View {
        Text("Welcome!")
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct LoginPicture: View {
    let picName : String
    var body: some View {
        Image(picName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:100,height: 100)
            .clipped()
            .cornerRadius(150)
    }
}
