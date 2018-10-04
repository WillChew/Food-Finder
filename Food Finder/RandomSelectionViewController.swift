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

class RandomSelectionViewController: UIViewController {
    
    //MARK: Global vars & outlets
    var requestManager: RequestManager!
    var restaruantArray = [Restaurant]()
    var currentLocation: CLLocation!
    var phoneNumber: String!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var latitude: String!
    var longitude: String!
    private let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var theMapView: GMSMapView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchStackView: UIStackView!
    @IBOutlet weak var magnifyingGlassButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 200
        
        phoneButton.isHidden = true
        nameLabel.text = "Find a restaurant"
        addressLabel.text = ""
        
        requestManager = RequestManager()
        locationTextField.delegate = self
        

        theMapView.addSubview(activityIndicator)
        activityIndicator.bounds = theMapView.bounds
        
        selectButton.layer.cornerRadius = 10
        selectButton.layer.borderColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0).cgColor
        selectButton.layer.borderWidth = 2
        
        tryAgainButton.layer.cornerRadius = 10
        tryAgainButton.layer.borderWidth = 2
        tryAgainButton.layer.borderColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0).cgColor
        
        
        
    }
    
  
    
    
    //MARK: Functions
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
    
    
    func findRestaurants() {
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
    
    
    func getRoute(from start:CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, mode: String? = "walking") {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://maps.googleapis.com")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.path = "/maps/api/directions/json"
        let startQueryItem = URLQueryItem(name: "origin", value: "\(start.latitude), \(start.longitude)")
        let destinationQueryItem = URLQueryItem(name: "destination", value: "\(destination.latitude), \(destination.longitude)")
        let sensorQueryItem = URLQueryItem(name: "sensor", value: "true")
        let keyQueryItem = URLQueryItem(name: "key", value: "AIzaSyC6qrRUA6K4AevKj76c8tKPBmIEbY5xcGc")
        components.queryItems = [startQueryItem, destinationQueryItem, sensorQueryItem, keyQueryItem]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                
            }
            else {
                do {
                    if let json : [String : Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : Any] {
                        
                        guard let routes = json["routes"] as? Array<Dictionary<String,Any?>> else {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                
                            }
                            return
                        }
                        
                        
                        if (routes.count > 0 ){
                            let overview_polyline = routes[0] as NSDictionary
                            let dictPolyline = overview_polyline["overview_polyline"] as? NSDictionary
                            
                            guard let points = dictPolyline?.object(forKey: "points") as? String else { return }
                            
                            DispatchQueue.main.async {
                                
                                
                                self.showPath(polyStr: points)
                                
                                self.activityIndicator.stopAnimating()
                                
                                let bounds = GMSCoordinateBounds(coordinate: start, coordinate: destination)
                                let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsetsMake(170,30,30,30))
                                self.theMapView.moveCamera(update)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                
                                
                            }
                        }
                    }
                }
                catch {
                    print("error in JSONSerialization")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        
                    }
                }
            }
        })
        task.resume()
        
    }
    
    func showPath(polyStr: String) {
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.strokeColor = .red
        polyline.map = theMapView
    }
    
    
    func changeDisplays() {
        phoneButton.isHidden = false
        theMapView.clear()
        activityIndicator.startAnimating()
        
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
            let displayNumber = String(format: "(%@) %@-%@", areaCodeStr, middleStr, lastFourStr)
            
            phoneButton.setTitle(displayNumber, for: .normal)
            
        }
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: randomRestaurant.latitude, longitude: randomRestaurant.longitude)
        marker.title = randomRestaurant.name
        marker.snippet = randomRestaurant.address
        marker.map = theMapView
        
        getRoute(from: currentLocation.coordinate, to: CLLocationCoordinate2D(latitude: randomRestaurant.latitude, longitude: randomRestaurant.longitude))
        
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
    
    @IBAction func magnifyingGlassButtonPressed(_ sender: UIButton) {
        
        magnifyingGlassButton.isHidden = true
        searchStackView.isHidden = false
    }
    @IBAction func selectRestaurantButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func makeCallButtonPressed(_ sender: UIButton) {
        
        guard let number = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(number)
        
    }
    
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        locationTextField.resignFirstResponder()
        magnifyingGlassButton.isHidden = false
        searchStackView.isHidden = true
        
        findRestaurants()
    }
   

    
}
//MARK: Map and location delegate methods
extension RandomSelectionViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
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
}

extension RandomSelectionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        findRestaurants()
        magnifyingGlassButton.isHidden = false
        searchStackView.isHidden = true
        return true
    }
    
}
