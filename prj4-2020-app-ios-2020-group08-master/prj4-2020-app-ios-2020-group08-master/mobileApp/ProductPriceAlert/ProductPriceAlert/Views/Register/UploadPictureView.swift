//
//  UploadPictureView.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 04.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI
import Foundation

struct UploadPictureView: View {
    //Fields used to store data
    @State var image = UIImage()
    //Booleans which are used to show the shee for the buttons
    @State private var isShowingImagePicker = false
    @State private var isShowingCamera = false
    @State private var isFinalize = false
    @State private var onEdit = false
    
    //source of the ui image picker this case camera
    @State var sourceType: UIImagePickerController.SourceType = .camera
    
    @EnvironmentObject var customerData : CustomerData
    @EnvironmentObject var loginCustomerData : LoginCustomerData
    @EnvironmentObject var editCustomerData : EditCustomerData
    
    let postman = EntityPostMan()
    
    @Binding var isOnEdit: Bool
    @Binding var labelValue: String
    
    @ObservedObject private var listLocation = ListGeneric<Location>()
    
    
    var body: some View {
        
        return
            NavigationView{
                VStack{
                    GreetingMessage(message:"Please upload or take a picture")
                    Spacer()
                    Image(uiImage: self.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width:200,height:200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black))
                        .clipped()
                        .padding(.all)
                    
                    HStack {
                        NiceButton(label: "Upload Image", logoBut: "folder.fill", width: 140, height: 30, action: {
                            self.isShowingImagePicker.toggle()
                        })
                            .sheet(isPresented: $isShowingImagePicker, content: {
                                ImagePickerView(isPresented: self.$isShowingImagePicker,seleImage: self.$image).environmentObject(self.editCustomerData).environmentObject(self.loginCustomerData)
                            })
                        
                        NiceButton(label: "Take Picture", logoBut: "camera.fill", width: 140, height: 30, action: {
                            self.isShowingCamera.toggle()
                        })
                            .sheet(isPresented: $isShowingCamera, content: {
                                ImagePicker(image: self.$image,isShown: self.$isShowingCamera , sourceType: self.sourceType).environmentObject(self.editCustomerData).environmentObject(self.loginCustomerData)
                            })
                        
                    }.onAppear(perform: self.listLocation.listFetch)
                        .onAppear{
                            print(self.listLocation.list)
                    }
                    
                    //after everything is done then go to the user profile
                    ZStack{
                        
                        if(!self.isOnEdit){
                            NavigationLink(destination: UserProfileView(loca: EntityFromJson<Location>(entity: Location(id: 0, street: "", postalCode: "", sNumber: "", city: "", country: "", longitude: "", latitude: ""), id: String(self.loginCustomerData.locId))).environmentObject(self.editCustomerData).environmentObject(self.loginCustomerData), isActive: $isFinalize){
                                Text("")
                            }
                            Button(action: {
                                //if it is not on edit mode we need to save everything to the DB as it is the final step
                                if(self.isOnEdit == false){
                                    //turn the image into a string
                                    
                                    var imageAsString = ""
                                    //resize the image if it is to big
                                    if self.image.cgImage != nil {
                                        print("not empty")
                                        if let img = self.image.resized(withPercentage: 0.1){
                                            imageAsString = self.postman.getStringFromImage(image: img)
                                        }
                                    }else{
                                        if let img = UIImage(systemName: "person"){
                                            imageAsString = self.postman.getStringFromImage(image: img)
                                        }
                                    }
                                    print("Count is: \(imageAsString.count)" )
                                    
                                    //create location and customer objects from all the data gathered till now
                                    var location = Location(id: 0, street: self.customerData.street, postalCode: self.customerData.postalCode, sNumber: self.customerData.sNumber, city: self.customerData.city, country: self.customerData.country, longitude: String(self.customerData.long), latitude: String(self.customerData.lat))
                                    
                                    var customer = Register(firstName: self.customerData.firstName, lastName: self.customerData.lastName, email: self.customerData.email, password: self.customerData.password, locationId: 0, image: imageAsString)
                                    
                                    let user = User(email: customer.email, password: customer.password)
                                    
                                    
                                    
                                    var locationId = 0
                                    
                                    for loc in self.listLocation.list {
                                        
                                        if(loc == location){
                                            location = loc
                                            locationId = loc.id
                                            print("loc id in loop= \(location.id)")
                                            
                                            break;
                                        }
                                        
                                    }
                                    
                                    //if the address exists already no need to resave it
                                    if(locationId > 0) {
                                        customer.locationId = locationId
                                        print("customer loc id id in first if= \(customer.locationId)")
                                        do{
                                            //jsonify the customer object
                                            let customerData = try JSONSerialization.data(withJSONObject: self.postman.getEntityDictionary(entity: customer), options: .init())
                                            
                                            //persist in the DB
                                            self.postman.register(request: customerData, resultType: Register.self){
                                                (customerResponse) in
                                                
                                                
                                                self.loginCustomerData.img = customer.image
                                                
                                                print("firstname is: " + self.loginCustomerData.firstName)
                                                //save the image using the newly save response
                                                
                                                self.loginCustomerData.locId = customer.locationId
                                                self.loginCustomerData.email = customer.email
                                                self.loginCustomerData.firstName = customer.firstName
                                                self.loginCustomerData.lastName = customer.lastName
                                                
                                                self.loginCustomerData.street = location.street
                                                self.loginCustomerData.sNumber = location.sNumber
                                                self.loginCustomerData.city = location.city
                                                self.loginCustomerData.country = location.country
                                                self.loginCustomerData.postalCode = location.postalCode
                                                
                                                do{
                                                    
                                                    let userData = try JSONSerialization.data(withJSONObject: self.postman.getEntityDictionary(entity: user), options: .init())
                                                    
                                                    self.postman.login(request: userData, resultType: User.self){
                                                        (userResponse) in
                                                        self.loginCustomerData.token = userResponse.token
                                                         self.isFinalize.toggle()
                                                    }
                                                    
                                                }catch let err{
                                                    debugPrint(err.localizedDescription)

                                                }
                                                
                                                
                                                
                                            }
                                        }catch let err{
                                            debugPrint(err.localizedDescription)
                                            
                                        }
                                        
                                        
                                    }else {
                                        
                                        do{
                                            //turn the local object into a json
                                            let dataLocation = try JSONSerialization.data(withJSONObject: self.postman.getEntityDictionary(entity: location), options: .init())
                                            //save the location in the DB
                                            self.postman.postData(request: dataLocation, resultType: Location.self){
                                                (locationResponse) in
                                                
                                                debugPrint(locationResponse)
                                                //take the saved id and change the customer id
                                                customer.locationId = locationResponse.id
                                                print("loc id = \(customer.locationId)")
                                                do{
                                                    //jsonify the customer object
                                                    let customerData = try JSONSerialization.data(withJSONObject: self.postman.getEntityDictionary(entity: customer), options: .init())
                                                    
                                                    //persist in the DB
                                                    self.postman.register(request: customerData, resultType: Register.self){
                                                        (customerResponse) in
                                                        self.loginCustomerData.img = customer.image
                                                        
                                                        self.loginCustomerData.locId = customer.locationId
                                                        self.loginCustomerData.email = customer.email
                                                        self.loginCustomerData.firstName = customer.firstName
                                                        self.loginCustomerData.lastName = customer.lastName
                                                        self.loginCustomerData.img = customer.image
                                                        
                                                        
                                                        self.loginCustomerData.street = location.street
                                                        self.loginCustomerData.sNumber = location.sNumber
                                                        self.loginCustomerData.city = location.city
                                                        self.loginCustomerData.country = location.country
                                                        self.loginCustomerData.postalCode = location.postalCode
                                                        
                                                        print("firstname is: " + self.loginCustomerData.firstName)
                                                        //save the image using the newly save response
                                                        
                                                        
                                                        do{
                                                            
                                                            let userData = try JSONSerialization.data(withJSONObject: self.postman.getEntityDictionary(entity: user), options: .init())
                                                            
                                                            self.postman.login(request: userData, resultType: User.self){
                                                                (userResponse) in
                                                                self.loginCustomerData.token = userResponse.token
                                                                 self.isFinalize.toggle()
                                                            }
                                                            
                                                        }catch let err{
                                                            debugPrint(err.localizedDescription)

                                                        }
                                                        
                                                    }
                                                }catch let err{
                                                    debugPrint(err.localizedDescription)
                                                    
                                                }
                                                
                                            }
                                            
                                        }catch let error{
                                            debugPrint(error.localizedDescription)
                                        }
                                        
                                    }
                                    
                                }
                                
                            }){
                                HStack{
                                    Image(systemName: "person.circle")
                                        .foregroundColor(.white)
                                    Text("Finalize")
                                        .foregroundColor(.white)
                                }
                                .frame(width: CGFloat(140),height: CGFloat(30))
                                .padding(.all)
                                .background(Color.green)
                                .cornerRadius(10.0)
                            }
                            
                        } else{
                            
                            NavigationLink(destination: EditProfile(email: self.$editCustomerData.email, password: self.$editCustomerData.password, firstname: self.$editCustomerData.firstName, lastname: self.$editCustomerData.lastName, street: self.$editCustomerData.street, sNumber: self.$editCustomerData.sNumber, postalCode: self.$editCustomerData.postalCode, country: self.$editCustomerData.country, city: self.$editCustomerData.city).environmentObject(self.editCustomerData).environmentObject(self.loginCustomerData), isActive: $onEdit){
                                Text("")
                            }
                            NiceButton(label: "Save edit Picture", logoBut: "", width: 140, height: 30, action: {
                                //if it is on edit moe just save the pic on the editcustomer data and change the value
                                if(self.image.cgImage != nil){
                                    
                                    if let img = self.image.resized(withPercentage: 0.1){
                                        self.editCustomerData.image = img
                                    }
                                }else{
                                    if let img = UIImage(systemName: "person"){
                                        self.editCustomerData.image = img
                                    }
                                }
                                self.editCustomerData.image.jpegData(compressionQuality: 0.1)
                                self.labelValue = ""
                                self.onEdit.toggle()
                            })
                        }
                        
                        
                        
                    }
                    Text(self.labelValue).foregroundColor(.red).padding(.all)
                    Spacer()
                }
            }.navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                .frame(minWidth: UIScreen.main.bounds.width, maxWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height-40, maxHeight: UIScreen.main.bounds.height-40,  alignment: .center)
                .padding(.bottom, 20)
    }
}


/*
 struct UploadPictureView_Previews: PreviewProvider {
 static var previews: some View {
 UploadPictureView(, isOnEdit: false)
 }
 }
 */

struct ImagePickerView: UIViewControllerRepresentable{
    
    @Binding var isPresented: Bool
    @Binding var seleImage:UIImage
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        let parent:ImagePickerView
        init(parent: ImagePickerView){
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                print(selectedImage)
                self.parent.seleImage = selectedImage
            }
            self.parent.isPresented = false
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

