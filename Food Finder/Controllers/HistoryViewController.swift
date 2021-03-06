//
//  HistoryViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2019-01-18.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData


class HistoryViewController: UIViewController {
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    
    var googleMapView = UIView()
    var mapView: GMSMapView?
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var cViewScreen = UIView()
    var tableScreen = UIView()
    var entriesArray = [Entry]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadItems()
        setupTableAndCollectionView()
        UserDefaults.standard.removeObject(forKey: "caption")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "address")
        UserDefaults.standard.removeObject(forKey: "date")
        
    }
    
    //MARK: Functions
    
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
        
    }
    
    func loadItems(with request:NSFetchRequest<Entry> = Entry.fetchRequest(), predicate: NSPredicate? = nil) {
        
        
        request.predicate = predicate
        do {
            entriesArray = try context.fetch(request)
        } catch {
            print("Error loading entries \(error)")
        }
        myTableView.reloadData()
        historyCollectionView.reloadData()
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
        
        if entriesArray.isEmpty == true {
            return 1
        } else {
            return entriesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCell", for: indexPath) as! HistoryTableViewCell
        
        
        if entriesArray.isEmpty == true {
            cell.restaurantPic.image = UIImage(named: "plus")
            cell.restaurantNameLabel.text = "Add New Entry"
            cell.restaurantAddressLabel.text = ""
            cell.restaurantDateLabel.text = ""
            cell.restaurantPic.contentMode = .scaleAspectFill
        } else {
            if let imageData = entriesArray[indexPath.row].image {
                cell.restaurantPic.image = UIImage(data: imageData)
                cell.restaurantPic.contentMode = .scaleToFill
                
            } else {
                cell.restaurantPic.image = UIImage(named: "noImage")
            }
            
            
            cell.restaurantNameLabel.text = entriesArray[indexPath.row].name
            cell.restaurantAddressLabel.text = entriesArray[indexPath.row].address
            
            
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
            
            if let visitDate = entriesArray[indexPath.row].date {
                
                let date = formatter.string(from: visitDate)
                cell.restaurantDateLabel.text = date
            }
        }
        
        cell.restaurantPic.layer.borderWidth = 2
        cell.restaurantPic.layer.borderColor = UIColor.black.cgColor
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if entriesArray.isEmpty == true {
            performSegue(withIdentifier: "newEntrySegue", sender: self)
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
            vc.entry = entriesArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let deleteEntry = self.entriesArray[indexPath.row]
        
        if editingStyle == .delete {
            context.delete(deleteEntry)
            
            do {
                try context.save()
            } catch {
                print("Error deleting")
            }
        }
        
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        
        do {
            entriesArray = try context.fetch(fetchRequest) as! [Entry]
        } catch {
            print("Error fetching Data from DB")
        }
        tableView.reloadData()
        
    }
    
    
}
extension HistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if entriesArray.isEmpty == false {
            return entriesArray.count
        } else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCell", for: indexPath) as! HistoryCollectionViewCell
        
        if entriesArray.isEmpty == true {
            cell.restaurantPicture.image = UIImage(named: "plus")
        } else {
            if let imageData = entriesArray[indexPath.row].image {
                cell.restaurantPicture.image = UIImage(data: imageData)
            } else {
                cell.restaurantPicture.image = UIImage(named: "noImage")
            }
        }
        
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if entriesArray.isEmpty == true {
            performSegue(withIdentifier: "newEntrySegue", sender: self)
        } else {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
            vc.entry = entriesArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    //    MARK: Searchbar functions
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        
        if searchBar.text != "" {
            loadItems(with: request, predicate: predicate)
        } else {
            loadItems()
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
    
    
    
    
}
