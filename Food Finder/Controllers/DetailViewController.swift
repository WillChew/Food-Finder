//
//  DetailViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2019-02-06.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    
    var entry: Entry!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var editNameTextF: UITextField!
    
    @IBOutlet weak var editAddressTextF: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        editAddressTextF.isHidden = true
        editNameTextF.isHidden = true
        if let imageData = entry.image {
            restaurantImage.image = UIImage(data: imageData)
        } else {
            restaurantImage.image = UIImage(named: "noImage")
        }
        restaurantNameLabel.text = entry.name
        captionTextView.text = entry.caption
        restaurantAddressLabel.text = entry.address
        
        
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.backgroundColor = .blue

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        saveButton.isHidden = false
        captionTextView.isEditable = true
        restaurantNameLabel.isHidden = true
        restaurantAddressLabel.isHidden = true
        editNameTextF.isHidden = false
        editAddressTextF.isHidden = false
        editNameTextF.text = entry.name
        editAddressTextF.text = entry.address
        captionTextView.text = entry.caption
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        return true
        
    }
    
    
   

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        restaurantAddressLabel.isHidden = false
        restaurantNameLabel.isHidden = false
        
        restaurantAddressLabel.text = editAddressTextF.text
        restaurantNameLabel.text = editNameTextF.text
        saveButton.isHidden = true
        editNameTextF.isHidden = true
        editAddressTextF.isHidden = true
        captionTextView.isEditable = false
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        entry.setValue(captionTextView.text, forKey: "caption")
        entry.setValue(editNameTextF.text, forKey: "name")
        entry.setValue(editAddressTextF.text, forKey: "address")
        
        do {
            try context.save()
        } catch {
            print("Error saving")
        }
        
    }
    
}
