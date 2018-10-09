//
//  SelectWithOptionsViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2018-10-08.
//  Copyright © 2018 Will Chew. All rights reserved.
//

import UIKit
import CoreLocation

class SelectWithOptionsViewController: UIViewController {
    
    @IBOutlet weak var restaurantTableView: UITableView!
    var priceButtonArray = [UIButton]()
    var priceArray = [Int]()
    let requestManager = RequestManager()
    var restaurantsArray = [Restaurant]()
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var oneDollarSignButton: UIButton!
    @IBOutlet weak var twoDollarSignsButton: UIButton!
    @IBOutlet weak var threeDollarSignsButton: UIButton!
    @IBOutlet weak var fourDollarSignsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocationUpdate()
        self.searchTermTextField.delegate = self
        self.locationTextField.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKB))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func getPic(_ indexPath: IndexPath) -> UIImage? {
        guard let urlStr = restaurantsArray[indexPath.row].imageURL, let url = URL(string: urlStr) else { return nil}
        let data = try! Data(contentsOf: url)
        guard let image = UIImage(data: data) else { return nil}
        return image
    }
    
    @objc func dismissKB(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    

    
    @IBAction func priceButtonPressed(_ sender: UIButton) {
        
        
        sender.isSelected = !sender.isSelected
        sender.tintColor = .clear
        sender.setTitleColor(.white, for: .normal)
        sender.setTitleColor(.green, for: .selected)
        
        
        //        switch sender.tag {
        //        case 1:
        //            print("1")
        //        case 2:
        //            print("2")
        //        case 3:
        //            print("3")
        //        case 4:
        //            print("4")
        //        default:
        //            return
        //        }
    }
    
    @IBAction func decideButtonPressed(_ sender: UIButton) {
        
        priceArray.removeAll()
        for button in priceButtonArray {
            if button.isSelected {
                priceArray.append(button.tag)
            }
        }
        
        let priceAsString = priceArray.map(String.init).joined(separator: ",")
        let latitudeStr = String(currentLocation.coordinate.latitude)
        let longitudeStr = String(currentLocation.coordinate.longitude)
        
        if locationTextField.text == "" {
            
            requestManager.getRestuarants(latitude: latitudeStr, longitude: longitudeStr, term: searchTermTextField.text, price: priceAsString) { (restaurants) in
                self.restaurantsArray = restaurants
                
                DispatchQueue.main.async {
                    self.restaurantTableView.reloadData()
                }
            }
            
        } else if searchTermTextField.text == "" {
            requestManager.getRestuarants(near: locationTextField.text, price: priceAsString) { (restaurants) in
                self.restaurantsArray = restaurants
                
                DispatchQueue.main.async {
                    self.restaurantTableView.reloadData()
                }
                
            }
        } else {
            requestManager.getRestuarants(near: locationTextField.text, term: searchTermTextField.text, price: priceAsString) { (restaurants) in
                self.restaurantsArray = restaurants
                
                DispatchQueue.main.async {
                    self.restaurantTableView.reloadData()
                }
            }
        }
    }
    

}

extension SelectWithOptionsViewController: CLLocationManagerDelegate, UITextFieldDelegate {
    
    func getLocationUpdate() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        locationManager.stopUpdatingLocation()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension SelectWithOptionsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCellTableViewCell
        let restaurant = restaurantsArray[indexPath.row]
        
        cell.restaurantNameLabel.text = restaurant.name
        cell.restaurantAddress.text = restaurant.address
        
        
        switch restaurantsArray[indexPath.row].rating {
        case 1 :
            cell.restaurantRatingImage.image = UIImage(named: "large_1")
        case 1.5 :
            cell.restaurantRatingImage.image = UIImage(named: "large_1_half")
        case 2 :
            cell.restaurantRatingImage.image = UIImage(named: "large_2")
        case 2.5 :
            cell.restaurantRatingImage.image = UIImage(named: "large_2_half")
        case 3 :
            cell.restaurantRatingImage.image = UIImage(named: "large_3")
        case 3.5 :
            cell.restaurantRatingImage.image = UIImage(named: "large_3_half")
        case 4 :
            cell.restaurantRatingImage.image = UIImage(named: "large_4")
        case 4.5 :
            cell.restaurantRatingImage.image = UIImage(named: "large_4_half")
        case 5 :
            cell.restaurantRatingImage.image = UIImage(named: "large_5")
        default:
            cell.restaurantRatingImage.image = UIImage(named: "large_0")
        }
        
        cell.restaurantImage.image = getPic(indexPath)
        cell.accessoryType = restaurant.selected == true ? .checkmark : .none
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        restaurantsArray[indexPath.row].selected = !restaurantsArray[indexPath.row].selected
        restaurantTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
}
