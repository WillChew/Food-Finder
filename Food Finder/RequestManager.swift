//
//  RequestManager.swift
//  Food Finder
//
//  Created by Will Chew on 2018-09-25.
//  Copyright © 2018 Will Chew. All rights reserved.
//

import UIKit
import CoreLocation



class RequestManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func getRestuarants(_ location: String, term: String = "vietnamese", price: String = "1,2,3,4", completion: @escaping([Restaurant]) -> ()){
        
        var restaurantArray = [Restaurant]()
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://api.yelp.com")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.path = "/v3/businesses/search"
        
        let locationQueryItem = URLQueryItem(name: "location", value: location)
        let termQueryItem = URLQueryItem(name: "term", value: term)
        let priceQueryItem = URLQueryItem(name: "price", value: price)
        let radiusQueryItem = URLQueryItem(name: "radius", value: "2500")
        components.queryItems = [locationQueryItem,termQueryItem,priceQueryItem, radiusQueryItem]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue("Bearer QCsxzDpQvN4jHRQjPxszCt55RVndyUZI6sOQZ1xF_sHk_ewwXItiHEOxV3IoKOcsdbfNbnrBZbew8a2PLjf2qe0VRBou758RWt5PYJ5iQz8u3amGTSgQokeug1MtW3Yx", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if (error == nil) {
                let statusCode = (response as! HTTPURLResponse).statusCode
                print(#line, "Success: \(statusCode)")
            } else if let error = error {
                print(#line, error.localizedDescription)
            }
            
            guard let data = data else { return }
            guard let jsonResult = try! JSONSerialization.jsonObject(with: data) as? Dictionary<String,Any?> else { return }
            let restaurants = jsonResult["businesses"] as! Array<Dictionary<String,Any?>>
            for restaurant in restaurants {
                let newRestaurant = Restaurant(context: self.context)
                
                guard let locationDict = restaurant["location"] as? Dictionary<String,Any?>, let address = locationDict["address1"] else { return }
                let rating = restaurant["rating"] as? Double
                newRestaurant.id = restaurant["id"] as? String
                newRestaurant.imageURL = restaurant["image_url"] as? String
                newRestaurant.name = restaurant["name"] as? String
                newRestaurant.phone = restaurant["display_phone"] as? String
                newRestaurant.rating = Double(rating!)
                newRestaurant.url = restaurant["url"] as? String
                newRestaurant.address = address as? String
                
                restaurantArray.append(newRestaurant)
              
                
            }
            completion(restaurantArray)
            
        })
        task.resume()
        session.finishTasksAndInvalidate()
        
        
    }
    
}