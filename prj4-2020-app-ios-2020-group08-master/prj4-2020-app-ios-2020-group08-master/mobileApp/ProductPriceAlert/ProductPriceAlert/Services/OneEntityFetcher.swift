//
//  GenericFetchList.swift
//  ProductPriceAlert
//
//  Created by Fotios Alatas on 08.04.20.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import Foundation
import SwiftUI

class CustomerFromJson : ObservableObject {
    
    @Published var customer : Customer
    
    var email : String
    
    init(customer: Customer, email: String) {
        self.customer = customer
        self.email = email
    }
    
    func fetchData(){
        if let url = URL(string:  ContentView.url + "/customers/" + self.email){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, respone, error) in
                if error == nil{
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        do{
                            let customerJson = try decoder.decode(Customer.self, from: safeData)
                            DispatchQueue.main.async {
                                self.customer = customerJson
                                
                            }
                        }catch{
                            print(error)
                        }
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    
}

class EntityFromJson<Entity : Decodable> : ObservableObject {
    
    @Published var entity : Entity
    
    var id : String
    
    init(entity: Entity, id: String) {
        self.entity = entity
        self.id = id
        fetchData()
    }
    
    func setIdAndFetch(id:String) {
        self.id = id
        fetchData()
    }
    
    func fetchData(){
        if let url = URL(string:  ContentView.url + "/" + String(describing: Entity.self).lowercased() + "s" + "/" + self.id){
//            print(url)
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, respone, error) in
                if error == nil{
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        do{
                            let entityJson = try decoder.decode(Entity.self, from: safeData)
                            DispatchQueue.main.async {
                                self.entity = entityJson
                            }
                        }catch{
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
}

class EntityPostMan {
    
    func register<Register: Codable>(request: Data, resultType : Register.Type, completion: @escaping(_
        result : String) -> Void){
        
        var urlRequest = URLRequest(url: URL(string: ContentView.url + "/register")!)
        
        urlRequest.httpMethod = "POST"
        
        
        urlRequest.httpBody = request
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            if (data != nil && data?.count != 0){
//                do{
                    DispatchQueue.main.async {
                        
                        _ = completion("success")
                    }
//                }catch let error {
//                    print(error.localizedDescription)
//                }
            }
            
        }.resume()
        
    }
    
    func login<User: Codable>(request: Data, resultType : User.Type, completion: @escaping(_
        result : LoginResponse) -> Void){
        
        var urlRequest = URLRequest(url: URL(string: ContentView.url + "/users/login")!)
        
        urlRequest.httpMethod = "POST"
        
        
        urlRequest.httpBody = request
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            if (data != nil && data?.count != 0){
                do{
                    let decodedData = try JSONDecoder().decode(LoginResponse.self, from: data!)
                    DispatchQueue.main.async {
                        _ = completion(decodedData)
                    }
                }catch let error {
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
        
    }
    
    func postData<Entity: Codable> (request: Data, resultType : Entity.Type, completion: @escaping(_
        result : Entity) -> Void){
        
        var urlRequest = URLRequest(url: URL(string: ContentView.url + "/" + String(describing: Entity.self).lowercased() + "s")!)
        
        urlRequest.httpMethod = "POST"
        
        
        urlRequest.httpBody = request
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest){ (data, response, error) in
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            if (data != nil && data?.count != 0){
                do{
                    
                    let resp = try JSONDecoder().decode(Entity.self, from: data!)
                    DispatchQueue.main.async {
                        _ = completion(resp)
                    }
                }catch let error {
                    print(error.localizedDescription)
                }
            }
            
        }.resume()
        
    }
    
    func putData<Entity: Codable> (id: String, request: Data, resultType : Entity.Type, completion: @escaping(_
        result : Entity) -> Void){
        print(id)
        var urlRequest = URLRequest(url: URL(string: ContentView.url + "/" + String(describing: Entity.self).lowercased() + "s" + "/" + id)!)
        
        urlRequest.httpMethod = "PUT"
        
        
        urlRequest.httpBody = request
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest){ data, response, error in
            
            guard error == nil else {
                print("Error: error calling PUT")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                
                return
            }
            do {                
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
            /*
             if let responseJSONData = try? JSONSerialization.jsonObject(with: respData , options: .allowFragments) {
             print("Response JSON data = \(responseJSONData)")
             }
             */
            
            
        }.resume()
        
    }
    
    func deleteEntity<Entity: Codable>(id: String, type: Entity.Type){
        
        var urlRequest = URLRequest(url: URL(string: ContentView.url + "/" + String(describing: Entity.self).lowercased() + "s" + "/" + id)!)
        
        urlRequest.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON")
                    return
                }
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                    print("Error: Could print JSON in String")
                    return
                }
                
                print(prettyPrintedJson)
            } catch {
                print("Error: Trying to convert JSON data to string")
                return
            }
        }.resume()
    }
    
    func getEntityDictionary<Entity: Codable>(entity: Entity) -> [String: Any] {
        let mirror = Mirror(reflecting: entity)
        
        var params = [String: Any]()
        
        for (name, value) in mirror.children {
            guard let name = name else { continue }
            
            if(name != "id"){
                //print("\(name): \(type(of: value)) = '\(value)'")
                params[name] = value
            }
        }
        return params
    }
    
    
    func getStringFromImage(image: UIImage ) -> String {
        var imageString = ""
        if(image.cgImage == nil){
            imageString = "Not available"
        }else {
            imageString = image.jpegData(compressionQuality: 0.1)!.base64EncodedString()
        }
        
        return imageString
    }
    
    
    
}


class ListGeneric<Entity: Codable> : ObservableObject {
    
    @Published var list = [Entity]()
    
    init() {
        listFetch()
    }
    
    func listFetch(){
        if let url = URL( string: ContentView.url + "/" + String(describing: Entity.self).lowercased() + "s" ){
            let session = URLSession(configuration: .default)
            print(url)
            let task = session.dataTask(with: url) { (data, respone, error) in
                if error == nil{
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        do{
                            let list = try decoder.decode([Entity].self, from: safeData)
                            DispatchQueue.main.async {
                                self.list = list
                            }
                        }catch{
                            print(error)
                        }
                    }
                    
                }
            }
            task.resume()
        }
        
    }
    
}

class ListWithFiler<Entity : Codable> : ObservableObject {
    @Published var list = [Entity]()
    @Published var name : String
    @Published var value : String
    
    init(name: String, value : String) {
        self.name = name
        self.value = value
        listFetch(name: self.name, value: self.value)
    }
    
    func listFetch(name: String, value: String){
        if let url = URL( string: ContentView.url + "/" + String(describing: Entity.self).lowercased() + "s" + "/" +
            "?filter[where][" + name + "]=" + value
            ){
            let session = URLSession(configuration: .default)
            print(url)
            let task = session.dataTask(with: url) { (data, respone, error) in
                if error == nil{
                    let decoder = JSONDecoder()
                    
                    if let safeData = data{
                        do{
                            let list = try decoder.decode([Entity].self, from: safeData)
                            DispatchQueue.main.async {
                                self.list = list
                            }
                        }catch{
                            print(error)
                        }
                    }
                    
                }
            }
            task.resume()
        }
        
    }
}
