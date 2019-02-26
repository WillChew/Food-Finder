//
//  Restaurant.swift
//  Food Finder
//
//  Created by Will Chew on 2019-01-22.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import Foundation

class Restaurant {
    
    var id : String
    var imageURL : String
    var name : String
    var phone : String
    var rating : Double
    var url : String
    var address : String
    var latitude : Double
    var longitude : Double
    var selected : Bool
    var reviewCount: Int
    
   
    init(name: String, selected: Bool, id: String, imageURL: String, phone: String, rating: Double, url: String, address: String, latitude: Double, longitude: Double, reviewCount: Int){
        self.name = name
        self.selected = false
        self.id = id
        self.imageURL = imageURL
        self.phone = phone
        self.rating = rating
        self.url = url
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.reviewCount = reviewCount
    }
    
    
    
    
    
    
    
    
}
