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
import GoogleMaps

class RandomSelectionViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var requestManager: RequestManager!
    var restaruantArray = [Restaurant]()
    var currentLocation: CLLocation!
    var phoneNumber: String!
//    var locationAddress: String!
//    lazy var geoCoder = CLGeocoder()
    var latitude: String!
    var longitude: String!
    private let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var theMapView: GMSMapView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 200
        
        
       
        
        
        phoneButton.isHidden = true
        nameLabel.text = "Find a random restaurant"
        addressLabel.text = ""
       
        requestManager = RequestManager()
        locationTextField.delegate = self

        theMapView.layer.borderWidth = 5
        theMapView.layer.borderColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0).cgColor
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: CLLocationManagerDelegate
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
        
        locationManager.startUpdatingLocation()
        
        theMapView.isMyLocationEnabled = true
        theMapView.settings.myLocationButton = true
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.startMonitoringSignificantLocationChanges()
        guard let location = locations.first else {
            return
        }
        
        theMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
        
        currentLocation = location as CLLocation
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
        phoneButton.isHidden = false
        
        let randomNumberi32 = arc4random_uniform(UInt32(self.restaruantArray.count))
        let randomNumberInt = Int(randomNumberi32)
        let randomRestaurant = self.restaruantArray[randomNumberInt]
        
        let restaurantRating = randomRestaurant.rating
        self.nameLabel.text = randomRestaurant.name
        self.addressLabel.text = randomRestaurant.address
        self.getRatingImage(restaurantRating)
        
        if randomRestaurant.phone == "" {
            phoneButton.titleLabel?.text = "No number available"
            phoneButton.isEnabled = false
        } else {
            guard let numberBefore = randomRestaurant.phone else { return }
            phoneNumber = String(numberBefore.dropFirst(2))
            
            
            
            
            let areaCode = phoneNumber.index(phoneNumber.startIndex, offsetBy: 0) ..< phoneNumber.index(phoneNumber.endIndex, offsetBy: -7)
            let middleThree = phoneNumber.index(phoneNumber.startIndex, offsetBy: 3) ..< phoneNumber.index(phoneNumber.endIndex, offsetBy: -4)
            let lastFour = phoneNumber.index(phoneNumber.startIndex, offsetBy: 6) ..< phoneNumber.endIndex
            
            let areaCodeStr = String(phoneNumber[areaCode])
            let middleStr = String(phoneNumber[middleThree])
            let lastFourStr = String(phoneNumber[lastFour])
            
            
            let displayNumber = String(format: "(%@) %@ - %@", areaCodeStr, middleStr, lastFourStr)
            
            //6479751430
            
            phoneButton.setTitle(displayNumber, for: .normal)
            
        }
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: randomRestaurant.latitude, longitude: randomRestaurant.longitude)
        marker.title = randomRestaurant.name
        marker.snippet = randomRestaurant.address
        marker.map = theMapView
        
    }
//        guard let imageURL = randomRestaurant.imageURL else { return }
//        downloadImage(from: imageURL)
    
    
    //MARK: - IGNORE (download images)
//    func getData(from urlString: String, completion: @escaping(Data?, URLResponse?, Error?) -> () ) {
//        guard let imageURL = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: imageURL, completionHandler: completion).resume()
//    }
//
//    func downloadImage(from urlString: String) {
//        getData(from: urlString) { (data, response, error) in
//            guard let data = data, error == nil else { return }
//            DispatchQueue.main.async {
//                self.restaurantImage.image = UIImage(data: data)
//            }
//        }
//    }
    
    //PRAGMA MARK: Button Actions
    
    @IBAction func selectRestaurantButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func makeCallButtonPressed(_ sender: UIButton) {
        
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number)
        
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
    

    

}


extension RandomSelectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}
