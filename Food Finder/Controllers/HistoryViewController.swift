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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        var mapFrame = CGRect.zero
        mapFrame.size.height = self.view.frame.height * 0.66
        mapFrame.size.width = self.view.frame.width
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 43.642567, longitude: -79.387054, zoom: 12)
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: historyCollectionView.frame.width/1.5, height: historyCollectionView.frame.height/1.5)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        
        
        
        historyCollectionView!.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }
    
  
    
}

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCollectionViewCell
        
        cell.frame.size.width = historyCollectionView.frame.width/1.5
        cell.frame.size.height = historyCollectionView.frame.height/1.5
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
