//
//  FilterLogic.swift
//  G8ProductPriceAlert
//
//  Created by Karla on 23/04/2020.
//  Copyright © 2020 Fontys UAS. All rights reserved.
//

//todo if no categories are set

import SwiftUI
struct FilterLogic {
   
    var min: Int
    var max: Int
    var categories: [String]
    var fetch : GenericFetchList<Product>

    

    init(min: String,max: String,cat: [String],fetch: GenericFetchList<Product> ){
        self.min = Int(min) ?? 0
        self.max = Int(max) ?? 0
        self.categories = cat
        self.fetch = fetch
        self.max = self.max == 0 ? setMax() : self.max
       
        if(categories.count == 0){
            filterByPrice()
        }
        else{
            filter()
        }
      
        
    }
    
     func filterByPrice(){
        
        fetch.requestSettings.where = ["price" : WhereOptions( between: [self.min,self.max])]
              
        fetch.requestSettings.offset = 0

        fetch.reload()
        


    }
    //filter all products from selected category and price
    func filter(){
     
        fetch.requestSettings.where = ["categoryName" : WhereOptions(inq: categories),
                                       "price" : WhereOptions( between: [self.min,self.max])]
        fetch.requestSettings.offset = 0

        fetch.reload()
        
                   
    }
    //if max price is not selected set it as max from db
    func setMax() -> Int{
        
        let res =  fetch.list.max(by:  { (a, b) -> Bool in
            return a.price < b.price
        })
            
        return res?.price ?? 500
        
    }

    
    
}
