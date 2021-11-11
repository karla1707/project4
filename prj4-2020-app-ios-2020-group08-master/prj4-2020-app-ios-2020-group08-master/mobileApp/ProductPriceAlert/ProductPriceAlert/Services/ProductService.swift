//
//  ProductManager.swift
//  ProductPriceAlert
//
//  Created by Karla on 05/04/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

import SwiftUI

class ProductService {
  

    static func updateNumberOfViews(product: Product){
        
        //increase number
        product.numberOfViews = product.numberOfViews + 1
        
        //to json
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(product)

        
        // send patch request
        let url = URL(string: ContentView.url + "/products/" + String(product.id))
        
        guard let requestUrl = url else { fatalError() }
              // Create URL Request
        var request = URLRequest(url: requestUrl)
              // Specify HTTP Method to use
        request.httpMethod = "PATCH"
              // Send HTTP Request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

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
                  
                
    
        }
        
        task.resume()
    }
    
  
    
   
  
}




