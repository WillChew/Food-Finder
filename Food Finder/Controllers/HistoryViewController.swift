//
//  HistoryViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2019-01-18.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import GoogleMaps

class HistoryViewController: UIViewController {
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var tabBar: UITabBarItem!
    
    var googleMapView = UIView()
    var mapView: GMSMapView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        
        setupMapAndCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func keyboardWillShow(sender: Notification) {
       
        
        UIView.animate(withDuration: 0.25) {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 200, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    @objc func keyboardWillHide(sender: Notification) {
       
        UIView.animate(withDuration: 0.25) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)}
    }
    
    //MARK: Functions
    
    fileprivate func setupMapAndCollectionView() {
        var mapFrame = CGRect.zero
        guard let navH = navigationController?.navigationBar.frame.size.height else { return }
        mapFrame.size.height = (screenHeight * 0.66) - navH
        mapFrame.size.width = screenWidth
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 12)
        mapView =   GMSMapView.map(withFrame: mapFrame, camera: camera)
        googleMapView = mapView!
        self.view.addSubview(googleMapView)
        
        self.view.addSubview(searchBar)
        self.view.bringSubviewToFront(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: historyCollectionView.topAnchor).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        //        googleMapView.bringSubviewToFront(searchBar)
        
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2DMake(43.642567, -79.387054)
        //        marker.title = "CN Tower"
        //        marker.snippet = "Toronto"
        //        marker.map = mapView
        
        
        historyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        historyCollectionView.topAnchor.constraint(equalTo: googleMapView.bottomAnchor).isActive = true
        historyCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        historyCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        historyCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width: screenWidth/2, height: screenHeight*0.33 - navH)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        historyCollectionView!.collectionViewLayout = layout
    }
    
    
    
}

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCollectionViewCell
        
        cell.frame.size.width = screenWidth/2
        cell.frame.size.height = screenHeight*0.33
        
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell Pressed")
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(43.642567, -79.387054)
        marker.title = "New"
        marker.snippet = "New"
        marker.map = mapView
        self.view.addSubview(googleMapView)
        mapView?.camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2DMake(43.642567, -79.387054), zoom: 13)
        googleMapView.reloadInputViews()
        
    }
    
    //MARK: Searchbar functions
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("pressed")
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    
    
    
    
    
}
