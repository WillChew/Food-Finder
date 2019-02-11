//
//  SelectWithOptionsViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2018-10-08.
//  Copyright © 2018 Will Chew. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage
import GoogleMaps
import SafariServices


class SelectWithOptionsViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    //MARK: Outlets
    
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBOutlet weak var decideButton: UIButton!
    @IBOutlet weak var helperButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchTermTextField: UITextField!
    @IBOutlet weak var oneDollarSignButton: UIButton!
    @IBOutlet weak var twoDollarSignsButton: UIButton!
    @IBOutlet weak var threeDollarSignsButton: UIButton!
    @IBOutlet weak var fourDollarSignsButton: UIButton!
    @IBOutlet var popoverView: UIView!
    @IBOutlet weak var popoverNameLabel: UILabel!
    @IBOutlet weak var popoverDismissButton: UIButton!
    @IBOutlet weak var popoverAddressLabel: UILabel!
    @IBOutlet weak var popoverAddButton: UIButton!
    
    
    
    
    //MARK: Variables
    var priceButtonArray = [UIButton]()
    var priceArray = [Int]()
    let requestManager = RequestManager()
    var restaurantsArray = [Restaurant]()
    var currentLocation: CLLocation!
    var locationManager = CLLocationManager()
    var selectedRestaurantsArray = [Restaurant]()
    var blurEffectView = UIVisualEffectView()
    var selectedRestaurant: Restaurant!
    var dismissPopoverTap: UITapGestureRecognizer!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLocationUpdate()
        setupButtons()
        
        
        self.searchTermTextField.delegate = self
        self.locationTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKB))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        restaurantTableView.delegate = self
        spinner.isHidden = true
        
        
        
    }
    
    //MARK: Functions
    @objc func dismissKB() {
        self.view.endEditing(true)
    }
    
    func changeButton() {
        if selectedRestaurantsArray.count == 0 {
            helperButton.setTitle("Tap And Hold to Select Some Restaurants", for: .normal)
            helperButton.isEnabled = false
        } else if selectedRestaurantsArray.count == 1 {
            helperButton.setTitle("View Yelp Page of \(selectedRestaurantsArray[0].name)", for: .normal)
            helperButton.isEnabled = true
        } else {
            helperButton.setTitle("Help Me Pick From These \(selectedRestaurantsArray.count) Restaurants", for: .normal)
            helperButton.isEnabled = true
        }
    }
    
    func setupButtons(){
        
        decideButton.layer.cornerRadius = 10
        decideButton.layer.borderColor = UIColor.black.cgColor
        decideButton.layer.borderWidth = 2
        decideButton.backgroundColor = .gray
        
        priceButtonArray.append(oneDollarSignButton)
        priceButtonArray.append(twoDollarSignsButton)
        priceButtonArray.append(threeDollarSignsButton)
        priceButtonArray.append(fourDollarSignsButton)
        
        let font = UIFont(name: "MarkerFelt-Wide", size: 14)!
        
        helperButton.titleLabel?.text = ""
        helperButton.titleLabel?.font = font
        helperButton.titleLabel?.textAlignment = .center
        helperButton.layer.cornerRadius = 10
        helperButton.layer.borderColor = UIColor.black.cgColor
        helperButton.layer.borderWidth = 2
        
        listButton.setTitle("View List", for: .normal)
        listButton.titleLabel?.font = font
        listButton.titleLabel?.textAlignment = .center
        listButton.layer.cornerRadius = 10
        listButton.layer.borderColor = UIColor.black.cgColor
        listButton.layer.borderWidth = 2
        
        oneDollarSignButton.layer.cornerRadius = oneDollarSignButton.frame.width/2
        twoDollarSignsButton.layer.cornerRadius = twoDollarSignsButton.frame.width/2
        threeDollarSignsButton.layer.cornerRadius = threeDollarSignsButton.frame.width/2
        fourDollarSignsButton.layer.cornerRadius = fourDollarSignsButton.frame.width/2
        
        helperButton.setTitle("Find What You Feel Like Eating First", for: .normal)
        helperButton.isEnabled = false
        
        
        
    }
    
    fileprivate func setupPopoverView() {
        popoverView.center = self.view.center
        popoverView.layer.cornerRadius = 10
        popoverView.layer.borderColor = UIColor.black.cgColor
        popoverView.layer.borderWidth = 3
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.view.addSubview(popoverView)
        
        var mapFrame = CGRect.zero
        mapFrame.size.height = 256
        mapFrame.size.width = 240
        
        var googleMapView = UIView(frame: mapFrame)
        googleMapView.backgroundColor = .black
        
        let camera = GMSCameraPosition.camera(withLatitude: selectedRestaurant.latitude, longitude: selectedRestaurant.longitude, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        mapView.layer.cornerRadius = 10
        googleMapView = mapView
        
        
        dismissPopoverTap = UITapGestureRecognizer(target: self, action: #selector(dismissPopover))
        self.view.addGestureRecognizer(dismissPopoverTap)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: selectedRestaurant.latitude, longitude: selectedRestaurant.longitude)
        marker.title = selectedRestaurant.name
        marker.snippet = selectedRestaurant.address
        marker.map = mapView
        
        
        popoverNameLabel.text = selectedRestaurant.name
        popoverAddressLabel.text = selectedRestaurant.address
        
        popoverDismissButton.layer.cornerRadius = 10
        popoverDismissButton.layer.borderWidth = 1
        popoverDismissButton.layer.borderColor = UIColor.black.cgColor
        
        popoverAddButton.layer.cornerRadius = 10
        popoverAddButton.layer.borderWidth = 1
        popoverAddButton.layer.borderColor = UIColor.black.cgColor
        popoverAddButton.setTitle("Add to List", for: .normal)
        
        popoverView.addSubview(googleMapView)
        
        self.view.bringSubviewToFront(popoverView)
    }
    
    
    @objc func dismissPopover(){
        removePopoverViewBlur()
        self.view.removeGestureRecognizer(dismissPopoverTap)
    }
    
    func removePopoverViewBlur(){
        popoverView.removeFromSuperview()
        blurEffectView.removeFromSuperview()
    }
    
    func showYelpPage(_ url: String){
        
        guard let yelpUrl = URL(string: url) else { return }
        let vc = SFSafariViewController(url: yelpUrl)
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: Buttons
    
    @IBAction func priceButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = .clear
        sender.setTitleColor(.white, for: .normal)
        sender.setTitleColor(.green, for: .selected)
    }
    
    @IBAction func popoverDismissButtonPressed(_ sender: UIButton) {
        removePopoverViewBlur()
        
    }
    
    @IBAction func popoverAddButtonPressed(_ sender: UIButton) {
        selectedRestaurant.selected = true
        selectedRestaurantsArray.append(selectedRestaurant)
        changeButton()
        restaurantTableView.reloadData()
        removePopoverViewBlur()
        
    }
    
    
    @IBAction func listButtonPressed(_ sender: UIButton) {
        restaurantsArray = selectedRestaurantsArray
        restaurantTableView.reloadData()
        
        let scrollIndexPath: IndexPath = IndexPath(row: NSNotFound, section: 0)
        restaurantTableView.scrollToRow(at: scrollIndexPath, at: .top, animated: true)

        
    }
    
    @IBAction func helperButtonPressed(_ sender: UIButton) {
        guard let randomSelectedRestaurant = selectedRestaurantsArray.randomElement() else { return }
        print(randomSelectedRestaurant.name)
        
        showYelpPage(randomSelectedRestaurant.url)
        
        
    }
    
    
    @IBAction func decideButtonPressed(_ sender: UIButton) {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        
        dismissKB()
        
        
        priceArray.removeAll()
        for button in priceButtonArray {
            if button.isSelected {
                priceArray.append(button.tag)
            }
        }
        
        
        var priceAsString = priceArray.map(String.init).joined(separator: ", ")
        if priceAsString == "" {
            priceAsString = "1,2,3,4"
        }
        let latitudeStr = String(currentLocation.coordinate.latitude)
        let longitudeStr = String(currentLocation.coordinate.longitude)
        
        if locationTextField.text == "" {
            
            requestManager.getRestuarants(latitude: latitudeStr, longitude: longitudeStr, term: searchTermTextField.text, price: priceAsString) { (restaurants) in
                self.restaurantsArray = restaurants
                
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.restaurantTableView.reloadData()
                }
            }
            
        } else if searchTermTextField.text == "" {
            requestManager.getRestuarants(near: locationTextField.text, price: priceAsString) { (restaurants) in
                self.restaurantsArray = restaurants
                
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    self.restaurantTableView.reloadData()
                }
                
            }
        } else {
            requestManager.getRestuarants(near: locationTextField.text, term: searchTermTextField.text, price: priceAsString) { (restaurants) in
                self.restaurantsArray = restaurants
                
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.spinner.isHidden = true
                    
                    self.restaurantTableView.reloadData()
                }
            }
        }
        changeButton()
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
        
        
        cell.tag = indexPath.row
        if restaurantsArray.count == 0 {
            cell.restaurantNameLabel.text = "No Restaurants Found"
            cell.restaurantAddress.text = "Change Search Options and Try Again"
        } else {
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
            
            
            cell.restaurantImage.sd_setImage(with:URL(string: restaurantsArray[indexPath.row].imageURL) ,placeholderImage: UIImage(named: "noImage"))
            
            cell.accessoryType = restaurant.selected == true ? .checkmark : .none
            
            
            
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRestaurant = restaurantsArray[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        setupPopoverView()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let add = UITableViewRowAction(style: .normal
        , title: "Add/Remove") { (action, indexPath) in
            
            
            self.restaurantsArray[indexPath.row].selected = !self.restaurantsArray[indexPath.row].selected
            
            
            if self.restaurantsArray[indexPath.row].selected == true {
                self.selectedRestaurantsArray.append(self.restaurantsArray[indexPath.row])
            } else {
                self.selectedRestaurantsArray = self.selectedRestaurantsArray.filter
                    { $0.selected == true }
                
            }
            
            
            self.changeButton()
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        add.backgroundColor = .lightGray
        
        return [add]
    }
    
}




