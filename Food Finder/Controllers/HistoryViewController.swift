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
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Functions
    
    fileprivate func setupMapAndCollectionView() {
        var mapFrame = CGRect.zero
        mapFrame.size.height = screenHeight * 0.66
        mapFrame.size.width = screenWidth
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 12)
        mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        googleMapView = mapView!
        
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2DMake(43.642567, -79.387054)
        //        marker.title = "CN Tower"
        //        marker.snippet = "Toronto"
        //        marker.map = mapView
        self.view.addSubview(googleMapView)
        
        historyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        historyCollectionView.topAnchor.constraint(equalTo: googleMapView.bottomAnchor).isActive = true
        historyCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        historyCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        historyCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.itemSize = CGSize(width: screenWidth/2, height: screenHeight*0.33)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        
        
        
        historyCollectionView!.collectionViewLayout = layout
    }
    
  
    
}

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    
    
}
