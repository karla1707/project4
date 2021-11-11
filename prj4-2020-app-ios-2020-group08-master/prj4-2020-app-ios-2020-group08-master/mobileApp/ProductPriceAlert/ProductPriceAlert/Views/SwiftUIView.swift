//
//  SwiftUIView.swift
//  ProductPriceAlert
//
//  Created by Karla on 04/04/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI


//this is created just for testing

struct SwiftUIView : View {
 
    @State private var products = [Product]()

    var body: some View {
    
        
       List(products, id: \.id) { item in
        NavigationLink(destination: ProductView(product: item, seller: EntityFromJson<Seller>(entity: Seller(id: 0, name: "", locationId: 1, logo: ""), id: String(item.sellerId)) )) {
            Text(item.name)
        }
            
        }.onAppear(perform: loadData)
    

}

    
    func loadData(){
        
        print("1")
       let url = URL(string: ContentView.url + "/products")
       guard let requestUrl = url else { fatalError() }
       // Create URL Request
       var request = URLRequest(url: requestUrl)
       // Specify HTTP Method to use
       request.httpMethod = "GET"
       // Send HTTP Request
       let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
           
           // Check if Error took place
           if let error = error {
               print("Error took place \(error)")
               return
           }
           
           // Read HTTP Response Status code
           if let response = response as? HTTPURLResponse {
               print("Response HTTP Status code: \(response.statusCode)")
           }
           
           // Convert HTTP Response Data to a simple String
        
           if let data = data, let dataString = String(data: data, encoding: .utf8) {
             //  print("Response data string:\n \(dataString)")
           
           // let res = try? JSONDecoder().decode(ProductList.self, from: data)
            let decoder = JSONDecoder()
             
            do {
                   let res = try decoder.decode(Array<Product>.self, from: data)

                DispatchQueue.main.async {
                    self.products = res
                }
               } catch {
                   print(error)
                
               }
            
            
           }
        
       }
       task.resume()
    }
    
    
}



