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
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    
    var googleMapView = UIView()
    var mapView: GMSMapView?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cViewScreen = UIView()
    var tableScreen = UIView()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        
        setupTableAndCollectionView()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        
      
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Functions
    
    @objc func keyboardWillShow(sender: Notification) {
       
        
        UIView.animate(withDuration: 0.25) {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 200, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    @objc func keyboardWillHide(sender: Notification) {
       
        UIView.animate(withDuration: 0.25) {
            self.view.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)}
    }

    
    
    
    fileprivate func setupTableAndCollectionView() {
        
    

        tableScreen.frame = CGRect.zero
        self.view.addSubview(tableScreen)
          tableScreen.addSubview(myTableView)
        
        
        
        tableScreen.translatesAutoresizingMaskIntoConstraints = false
        tableScreen.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableScreen.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableScreen.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableScreen.backgroundColor = .red
        
        
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.topAnchor.constraint(equalTo: tableScreen.topAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: tableScreen.bottomAnchor).isActive = true
        myTableView.rightAnchor.constraint(equalTo: tableScreen.rightAnchor).isActive = true
        myTableView.leftAnchor.constraint(equalTo: tableScreen.leftAnchor).isActive = true
        
        cViewScreen.frame = CGRect.zero
        self.view.addSubview(cViewScreen)
        cViewScreen.addSubview(historyCollectionView)
        
        cViewScreen.translatesAutoresizingMaskIntoConstraints = false
        cViewScreen.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        cViewScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        cViewScreen.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cViewScreen.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        cViewScreen.backgroundColor = .black
        
        historyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        historyCollectionView.topAnchor.constraint(equalTo: cViewScreen.topAnchor).isActive = true
        historyCollectionView.bottomAnchor.constraint(equalTo: cViewScreen.bottomAnchor).isActive = true
        historyCollectionView.leftAnchor.constraint(equalTo: cViewScreen.leftAnchor).isActive = true
        historyCollectionView.rightAnchor.constraint(equalTo: cViewScreen.rightAnchor).isActive = true

        
      
//        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets.zero
//        
//        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        layout.scrollDirection = .vertical
//        historyCollectionView!.collectionViewLayout = layout
        
        
        
    }
    
    func addPopoverView(){
      
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {

        
        
    }
    
   
    @IBAction func segControllerPressed(_ sender: UISegmentedControl) {
        if segControl.selectedSegmentIndex == 0 {
            cViewScreen.alpha = 1
            tableScreen.alpha = 0
        } else {
            cViewScreen.alpha = 0
            tableScreen.alpha = 1
        }
        
    }
}
    
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCell", for: indexPath) as! HistoryTableViewCell
        
        cell.restaurantPic.image = UIImage(named: "Telephone")
        cell.restaurantNameLabel.text = "Bang Bang Ice Cream and Bakery"
        cell.restaurantAddressLabel.text = "1543 Dundas Street West"
        cell.restaurantRatingLabel.text = "4"
        
        
        return cell
    }
    
    
    
    
}

extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCollectionViewCell
        
 
        
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell Pressed")
        
        
    }

    
//    MARK: Searchbar functions

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("pressed")
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }


    
    
    
    
    
}
