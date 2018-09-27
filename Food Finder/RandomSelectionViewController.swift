//
//  RandomSelectionViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2018-09-25.
//  Copyright © 2018 Will Chew. All rights reserved.
//

import UIKit
import CoreGraphics
import CoreLocation

class RandomSelectionViewController: UIViewController, CLLocationManagerDelegate {
    
    var requestManager: RequestManager!
    var restaruantArray = [Restaurant]()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
//    var locationAddress: String!
//    lazy var geoCoder = CLGeocoder()
    var latitude: String!
    var longitude: String!
    
    
    @IBOutlet weak var phoneButton: UIButton!
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

        restaurantImage.layer.borderWidth = 5
        restaurantImage.layer.borderColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0).cgColor
        
        
        fetchCurrentLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func selectRestaurantButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func makeCallButtonPressed(_ sender: UIButton) {
        print("Button pressed")
        
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        locationTextField.resignFirstResponder()
        
        if locationTextField.text == "" {
            requestManager.getRestuarants(latitude: latitude, longitude: longitude) { (restaurants) in
                self.restaruantArray = restaurants
                
                DispatchQueue.main.async {
                    self.changeDisplays()
                }
            }
            
        } else {
            
            requestManager.getRestuarants(locationTextField.text!) { (restaurants) in
                self.restaruantArray = restaurants
                
                
                DispatchQueue.main.async {
                    
                    self.changeDisplays()

                }
            }
        }
        
    }
    
    func fetchCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 200
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.startMonitoringSignificantLocationChanges()
        currentLocation = locations[0] as CLLocation
        latitude = String(currentLocation.coordinate.latitude)
        longitude = String(currentLocation.coordinate.longitude)
        

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#line, "Failed to get location")
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
    
    func changeDisplays() {
        let randomNumberi32 = arc4random_uniform(UInt32(self.restaruantArray.count))
        let randomNumberInt = Int(randomNumberi32)
        let randomRestaurant = self.restaruantArray[randomNumberInt]
        
        let restaurantRating = randomRestaurant.rating
        self.nameLabel.text = randomRestaurant.name
        self.addressLabel.text = randomRestaurant.address
        self.phoneButton.titleLabel?.text = randomRestaurant.phone
        self.getRatingImage(restaurantRating)
        
        guard let imageURL = randomRestaurant.imageURL else { return }
        downloadImage(from: imageURL)
    }
    
    func getData(from urlString: String, completion: @escaping(Data?, URLResponse?, Error?) -> () ) {
        guard let imageURL = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: imageURL, completionHandler: completion).resume()
    }
    
    func downloadImage(from urlString: String) {
        getData(from: urlString) { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.restaurantImage.image = UIImage(data: data)
            }
        }
    }
    
//    func makePhoneCall(call number: String){
//        let url: NSURL = URL(string: <#T##String#>)
//    }

}
extension RandomSelectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
