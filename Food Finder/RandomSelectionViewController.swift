//
//  RandomSelectionViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2018-09-25.
//  Copyright © 2018 Will Chew. All rights reserved.
//

import UIKit
import CoreGraphics

class RandomSelectionViewController: UIViewController {
    
    var requestManager: RequestManager!
    var restaruantArray = [Restaurant]()
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestManager = RequestManager()
        locationTextField.delegate = self
        searchButton.layer.borderColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0).cgColor
        restaurantImage.layer.borderWidth = 2
        restaurantImage.layer.borderColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0).cgColor
        searchButton.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func locationTextFieldPressed(_ sender: UITextField) {
       
        
    }
    
    @IBAction func selectRestaurantButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
       
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        locationTextField.resignFirstResponder()
        requestManager.getRestuarants(locationTextField.text!) { (restaurants) in
            self.restaruantArray = restaurants
            
            DispatchQueue.main.async {
                
                let randomNumberi32 = arc4random_uniform(UInt32(self.restaruantArray.count))
                let randomNumberInt = Int(randomNumberi32)
                
                let restaurantRating = self.restaruantArray[randomNumberInt].rating
                self.nameLabel.text = self.restaruantArray[randomNumberInt].name
                self.addressLabel.text = self.restaruantArray[randomNumberInt].address
                self.phoneLabel.text = self.restaruantArray[randomNumberInt].phone
                
                self.getRatingImage(restaurantRating)
               
                
                
            }
        }
        
    }
    
    func getRatingImage(_ restaurantRating: Double) {
        switch restaurantRating {
        case 1 :
            self.ratingImage.image = UIImage(named: "large_1")
            print(restaurantRating)
        case 1.5 :
            self.ratingImage.image = UIImage(named: "large_1_half")
            print(restaurantRating)
            
        case 2 :
            self.ratingImage.image = UIImage(named: "large_2")
            print(restaurantRating)
            
        case 2.5 :
            self.ratingImage.image = UIImage(named: "large_2_half")
            print(restaurantRating)
            
        case 3 :
            self.ratingImage.image = UIImage(named: "large_3")
            print(restaurantRating)
            
        case 3.5 :
            self.ratingImage.image = UIImage(named: "large_3_half")
            print(restaurantRating)
            
        case 4 :
            self.ratingImage.image = UIImage(named: "large_4")
            print(restaurantRating)
            
        case 4.5 :
            self.ratingImage.image = UIImage(named: "large_4_half")
            print(restaurantRating)
            
        case 5 :
            self.ratingImage.image = UIImage(named: "large_5")
            print(restaurantRating)
            
        default:
            self.ratingImage.image = UIImage(named: "large_0")
            print(restaurantRating)
            
        }
    }
}

extension RandomSelectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
