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
    
    @IBOutlet weak var pastFutureSegControl: UISegmentedControl!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    var googleMapView: UIView?
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        var mapFrame = CGRect.zero
        mapFrame.size.height = self.view.frame.height/2
        mapFrame.size.width = self.view.frame.width
        
        var googleMapView = UIView(frame: mapFrame)
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 12)
        let mapView = GMSMapView.map(withFrame: mapFrame, camera: camera)
        googleMapView = mapView
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        self.view.addSubview(googleMapView)
        
        historyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        historyCollectionView.topAnchor.constraint(equalTo: googleMapView.bottomAnchor).isActive = true
        historyCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        historyCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        historyCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        // Do any additional setup after loading the view.
    }
    @IBAction func pastFutureSegCPressed(_ sender: UISegmentedControl) {
        
//        print(pastFutureSegControl.selectedSegmentIndex)
//
//        if pastFutureSegControl.selectedSegmentIndex == 0 {
//            historyCollectionView.isHidden = false
//            googleMapView!.removeFromSuperview()
//            historyCollectionView.reloadData()
//        } else {
//            historyCollectionView.isHidden = true
//            self.view.addSubview(googleMapView!)
//            historyCollectionView.reloadData()
//        }
    }
    
    
}

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCollectionViewCell
        
        
        
        
        return cell
    }
    
}
