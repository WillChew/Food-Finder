//
//  NewEntryTableViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2019-02-02.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class NewEntryTableViewController: UITableViewController {
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var pictureCaptionTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
