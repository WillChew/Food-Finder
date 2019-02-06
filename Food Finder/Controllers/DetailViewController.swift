//
//  DetailViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2019-02-06.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    
    var entry: Entry!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageData = entry.image {
            restaurantImage.image = UIImage(data: imageData)
        } else {
            restaurantImage.image = UIImage(named: "noImage")
        }
        restaurantNameLabel.text = entry.name
        captionTextView.text = entry.caption

        // Do any additional setup after loading the view.
    }
    


}
