//
//  EditProfile.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 10.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

struct EditProfile: View {
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var editCustomerData : EditCustomerData
    
    @State private var isPresEdit: Bool = false
    @State private var goToProfile: Bool = false
    
    
    @State var labelValue : String = ""
    //used as bindings in order to preload the data
    @Binding var email: String
    @Binding var password: String
    @Binding var firstname: String
    @Binding var lastname: String
    @Binding var street: String
    @Binding var sNumber: String
    @Binding var postalCode: String
    @Binding var country: String
    @Binding var city: String
    
    //Postman is used to post or/and update the entities in the DB
    let postman = EntityPostMan()
    
    //get the list of locations when needed
    @ObservedObject private var listLocation = ListGeneric<Location>()
    
    var body: some View {
        
        //get the coordinates of any given address
        let coordiret = CoordinatorRetriever(address: self.sNumber + "," + self.street + "," + self.city + "," + self.postalCode + "," + self.country)
        
        return
            NavigationView{
                VStack{
                    
                    GreetingMessage(message: "Edit and tap Save")
                    ZStack{
                        NavigationLink(destination: UserProfileView(loca: EntityFromJson<Location>(entity: Location(id: 0, street: "", postalCode: "", sNumber: "", city: "", country: "", longitude: "", latitude: ""), id: String(self.loginCustomerData.locId))).environmentObject(self.loginCustomerData).environmentObject(self.editCustomerData), isActive: $goToProfile){
                            Text("")
                        }
                        ZStack{
                            Button(action: {
                                self.goToProfile.toggle()
                            }){
                                HStack{
                                    Image(uiImage: UIImage(systemName: "person")!).resizable()
                                        .scaledToFill()
                                        .frame(width:20,height:20)
                                        .clipShape(Circle())
                                        .padding(.all)
                                    Text("Profile").foregroundColor(.blue)
                                }
                                
                            }
                        }
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 250))
                    
                    List{
                        GeneralFields(fieldValue: $email,placeholder: "Email...").padding(.horizontal)
                            .disabled(true)
                        BorderlessFields(fieldValue: $firstname,placeholder: "Name...").padding(.horizontal)
                        BorderlessFields(fieldValue: $lastname,placeholder: "Lastname...").padding(.horizontal)
                        BorderlessFields(fieldValue: $street,placeholder: "Street...").padding(.horizontal)
                        BorderlessFields(fieldValue: $sNumber,placeholder: "Number...").padding(.horizontal)
                        BorderlessFields(fieldValue: $postalCode,placeholder: "Postal Code...").padding(.horizontal)
                        BorderlessFields(fieldValue: $city,placeholder: "City...").padding(.horizontal)
                        BorderlessFields(fieldValue: $country,placeholder: "Country...").padding(.horizontal)
                        PasswordTextFieldNoBorder(password: $password)
                    }.frame(height: UIScreen.main.bounds.width * 0.8, alignment: .center)
                        .onAppear(perform: self.listLocation.listFetch)
                    
                    Text(self.labelValue).foregroundColor(Color.red) //Error message display
                    
                    HStack{
                        NiceButton(label: "Save Changes", logoBut: "tray.and.arrow.down.fill", width: 140, height: 30, action: {
                            self.listLocation.listFetch()
                            //Input checks based on REGEX
                            if(!self.email.EmailFieldValidation(self.email)){
                                self.labelValue = "Not a valid email"
                            }else if (!self.password.isEmpty){
                                
                                if(!self.password.PasswordValidation(self.password)){
                                    self.labelValue = "Only letters and Numbers for password"
                                    
                                }else if (self.password.count < 8){
                                    self.labelValue = "The password needs to be at least 8 characters"
                                }else{
                                    let user = User(email: self.email, password: self.password)
                                    
                                    do{
                                        let userData = try JSONSerialization.data(withJSONObject: self.postman.getEntityDictionary(entity: user), options: .init())
                                        
                                        self.postman.putData(id: user.email, request: userData, resultType: User.self){
                                            (userResponse) in
                                            
                                            print(userResponse)
                                        }
                                        
                                    }catch let error{
                                        debugPrint(error.localizedDescription)
                                    }
                                }
                                
                            }else if (!self.firstname.TextFieldValidation(self.firstname)){
                                self.labelValue = "Non valid name it needs to contain at least 2 letters"
                            }else if (!self.lastname.TextFieldValidation(self.lastname)){
                                self.labelValue = "Non valid lastname it needs to contain at least 2 letters"
                            } else if(!self.street.TextFieldValidation(self.street)){
                                self.labelValue = "Non valid street name"
                            }else if (!self.sNumber.TextWithNumbersOnly(self.sNumber)){
                                self.labelValue = "Non valid street number"
                            }else if (!self.postalCode.TextWithNumbersOnly(self.postalCode)){
                                self.labelValue = "Non valid Postal code"
                            }else if (!self.city.TextFieldValidation(self.city)){
                                self.labelValue = "Non valid city name"
                            }else if (!self.city.TextFieldValidation(self.country)){
                                self.labelValue = "Non valid country name"
                            }else{
                                print(self.email)
                                //store the values in the editcustomer data
                                self.editCustomerData.email = self.email
                                self.editCustomerData.firstName = self.firstname
                                self.editCustomerData.lastName = self.lastname
                                self.editCustomerData.street = self.street
                                self.editCustomerData.sNumber = self.sNumber
                                self.editCustomerData.postalCode = self.postalCode
                                self.editCustomerData.city = self.city
                                self.editCustomerData.country = self.country
                                //Unwrapp the latitude and longitude
                                if let lat = coordiret.latitude{
                                    self.editCustomerData.lat = lat
                                }
                                
                                if let long = coordiret.longitude{
                                    self.editCustomerData.long = long
                                }
                                //create two objects of Location and Customer using the editcustomerData values
                                var location = Location(id: self.loginCustomerData.locId, street: self.editCustomerData.street, postalCode: self.editCustomerData.postalCode, sNumber: self.editCustomerData.sNumber, city: self.editCustomerData.city, country: self.editCustomerData.country, longitude: String(self.editCustomerData.long), latitude: String(self.editCustomerData.lat))
                                
                                let imageS = self.postman.getStringFromImage(image: self.editCustomerData.image)
                                
                                var custo = Customer(firstName: self.editCustomerData.firstName, lastName: self.editCustomerData.lastName, email: self.editCustomerData.email, locationId: self.loginCustomerData.locId, image: imageS)
                                
                                
                                var locationID = 0
                                //if the new location exists already use the id tto just update the ud
                                for loc in self.listLocation.list {
                                    if(self.listLocation.list.isEmpty){
                                        print("TRUE")
                                    }
                                    if(loc == location){
                                        location = loc
                                        locationID = loc.id
                                        print("location is: \(locationID)")
                                        break;
                                    }
                                    
                                }
                                
                                print("location is: \(locationID)")
                                //if the id is bigger than 0, so it is an old id then just update the customer
                                //if it is 0 then a new address is required
                                if(locationID > 0){
                                    //set the customer id befire save
                                    custo.locationId = locationID
                                    print("custo loc id is :  \(custo.locationId)")
                                    print("email is : " + self.loginCustomerData.email)
                                    print("editemial is : " + self.editCustomerData.editEmail)
                                    
                                    print("password is " + self.password)
                                    print("--------------")
                                    do{
                                        //Jsonify the customer data
                                        let customerData = try JSONSerialization.data(withJSONObject: self.postman.getEntityDictionary(entity: custo), options: .init())
                                        //update the customer
                                        self.postman.putData(id: self.loginCustomerData.email, request: customerData, resultType: Customer.self){
                                            
                                            (customerResponse) in
                                            
                                            
                                        }
                                        
                                    }catch let error {
                                        debugPrint(error)
                                    }
                                    
                                    self.loginCustomerData.email = custo.email
                                    self.loginCustomerData.firstName = custo.firstName
                                    self.loginCustomerData.lastName = custo.lastName
                                    self.loginCustomerData.locId = custo.locationId
                                    
                                    if !custo.image.isEmpty{
                                        self.loginCustomerData.img = custo.image
                                        self.editCustomerData.img = custo.image
                                        
                                    }else{
                                        if let img = UIImage(systemName: "person"){
                                            self.loginCustomerData.img = self.postman.getStringFromImage(image: img)
                                            self.editCustomerData.img = self.loginCustomerData.img
                                        }
                                        
                                    }
                                    
                                    //location related login data
                                    self.loginCustomerData.street = location.street
                                    self.loginCustomerData.postalCode = location.postalCode
                                    self.loginCustomerData.sNumber = location.sNumber
                                    self.loginCustomerData.country = location.country
                                    self.loginCustomerData.city = location.city
                                    
                                }else {
                                    print("editemial is : " + self.editCustomerData.editEmail)
                                    
                                    debugPrint(location)
                                    
                                    do{
                                        let dataLocation = try JSONSerialization.data(withJSONObject: self.postman.getEntityDictionary(entity: location), options: .init())
                                        
                                        //first save the location
                                        
                                        self.postman.postData(request: dataLocation, resultType: Location.self){
                                            (locationResponse) in
                                            //set the location id
                                            custo.locationId = locationResponse.id
                                            
                                            do{
                                                //update the customer with all the new info
                                                let customerData = try JSONSerialization.data(withJSONObject: self.postman.getEntityDictionary(entity: custo), options: .init())
                                                
                                                
                                                self.postman.putData(id: self.editCustomerData.editEmail, request: customerData, resultType: Customer.self){
                                                    (customerResponse) in
                                                    
                                                    //Here
                                                    self.loginCustomerData.firstName = custo.firstName
                                                    self.loginCustomerData.lastName = custo.lastName
                                                    self.loginCustomerData.locId = custo.locationId
                                                    
                                                    if !custo.image.isEmpty{
                                                        self.loginCustomerData.img = custo.image
                                                        self.editCustomerData.img = custo.image
                                                        print("Customer image")
                                                        print(self.loginCustomerData.img)
                                                    }else{
                                                        if let img = UIImage(systemName: "person"){
                                                            self.loginCustomerData.img = self.postman.getStringFromImage(image: img)
                                                            self.editCustomerData.img = self.loginCustomerData.img
                                                        }
                                                        
                                                    }
                                                    //location related login data
                                                    self.loginCustomerData.street = location.street
                                                    self.loginCustomerData.postalCode = location.postalCode
                                                    self.loginCustomerData.sNumber = location.sNumber
                                                    self.loginCustomerData.country = location.country
                                                    self.loginCustomerData.city = location.city
                                                    
                                                    if let lat = Double(location.latitude){
                                                        self.loginCustomerData.lat = lat
                                                    }
                                                    
                                                    if let long = Double(location.longitude){
                                                        self.loginCustomerData.long = long
                                                    }
                                                    
                                                }
                                            }catch let err{
                                                debugPrint(err.localizedDescription)
                                                
                                            }
                                            
                                        }
                                        
                                    }catch let error {
                                        debugPrint(error)
                                    }
                                    
                                    
                                }
                                //set the lable value as nothing
                                self.labelValue = ""
                                //empty the editcustomer data we do not need it
                                //self.editCustomerData.reset()
                            }
                        })
                        
                        ZStack{
                            //take user to the upload picture view to upload their view
                            NavigationLink(destination:UploadPictureView(isOnEdit: self.$loginCustomerData.isOnEdit,labelValue: self.$editCustomerData.userMessage).environmentObject(self.loginCustomerData).environmentObject(self.editCustomerData), isActive: $isPresEdit){
                                Text("")
                            }
                            Button(action: {
                                
                                self.editCustomerData.email = self.email
                                self.editCustomerData.firstName = self.firstname
                                self.editCustomerData.lastName = self.lastname
                                self.editCustomerData.street = self.street
                                self.editCustomerData.sNumber = self.sNumber
                                self.editCustomerData.postalCode = self.postalCode
                                self.editCustomerData.city = self.city
                                self.editCustomerData.country = self.country
                                self.editCustomerData.password = self.password
                                
                                //Unwrapp the latitude and longitude
                                if let lat = coordiret.latitude{
                                    self.editCustomerData.lat = lat
                                    print("lat is : \(lat)")
                                }
                                
                                if let long = coordiret.longitude{
                                    self.editCustomerData.long = long
                                }
                                //take the user to the upload picture
                                self.editCustomerData.userMessage = "Select a Picture and tap Finalize"
                                self.loginCustomerData.isOnEdit = true
                                self.isPresEdit.toggle()
                            }){
                                HStack{
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                    Text("New Picture")
                                        .foregroundColor(.white)
                                }
                                .frame(width: CGFloat(140),height: CGFloat(30))
                                .padding(.all)
                                .background(Color.green)
                                .cornerRadius(10.0)
                            }
                            
                        }
                    }
                    
                    Spacer()
                }
            }.navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height-150, maxHeight: UIScreen.main.bounds.height-150,  alignment: .center)
                
                .padding(.bottom)
        
    }
}

func getLocId(email: String, customers: [Customer]) -> Int {
    var locid = 0
    for customer in customers {
        if(customer.email == email){
            locid = customer.locationId
            break
        }
    }
    
    return locid
}
