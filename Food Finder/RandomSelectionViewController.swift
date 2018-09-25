//
//  RandomSelectionViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2018-09-25.
//  Copyright © 2018 Will Chew. All rights reserved.
//

import UIKit
import CoreGraphics

class RandomSelectionViewController: UIViewController {
    
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton.layer.borderColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.0).cgColor
        searchButton.layer.borderWidth = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func selectRestaurantButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: UIButton) {
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
    
}

