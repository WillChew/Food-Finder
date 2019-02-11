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
    
    
    var entry: Entry!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dateFormatter = DateFormatter()
    var newDate: Date!
    
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddressLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var editDateTextField: UITextField!
    @IBOutlet weak var editNameTextF: UITextField!
    @IBOutlet weak var editAddressTextF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitialLoad()
        
        
    }
    
    @objc func viewTapped(){
        self.view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        editDateTextField.text = dateFormatter.string(from: sender.date)
        newDate = sender.date
    }
    fileprivate func setupInitialLoad() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        saveButton.isHidden = true
        editAddressTextF.isHidden = true
        editNameTextF.isHidden = true
        editDateTextField.isHidden = true
        if let imageData = entry.image {
            restaurantImage.image = UIImage(data: imageData)
        } else {
            restaurantImage.image = UIImage(named: "noImage")
        }
        if let visitDate = entry.date {
            let date = dateFormatter.string(from: visitDate)
            dateLabel.text = date
        } else {
            dateLabel.text = ""
        }
        
        
        restaurantNameLabel.text = entry.name
        captionTextView.text = entry.caption
        restaurantAddressLabel.text = entry.address
        
        
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.backgroundColor = .blue
        
        blurView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        restaurantNameLabel.alpha = 1
        
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        editDateTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        navigationItem.title = entry.name
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        saveButton.isHidden = false
        captionTextView.isEditable = true
        restaurantNameLabel.isHidden = true
        restaurantAddressLabel.isHidden = true
        dateLabel.isHidden = true
        editDateTextField.isHidden = false
        editNameTextF.isHidden = false
        editAddressTextF.isHidden = false
        editNameTextF.text = entry.name
        editAddressTextF.text = entry.address
        captionTextView.text = entry.caption
        if let date = entry.date {
            
            editDateTextField.text = dateFormatter.string(from: date)
        }
        
        captionTextView.backgroundColor = .white
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.title = "Edit Entry"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        return true
        
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        restaurantAddressLabel.isHidden = false
        restaurantNameLabel.isHidden = false
        dateLabel.isHidden = false
        restaurantAddressLabel.text = editAddressTextF.text
        restaurantNameLabel.text = editNameTextF.text
        
        
        if newDate != nil {
            dateLabel.text = dateFormatter.string(from: newDate)
        } else if entry.date != nil {
            guard let saveDate = entry.date else { return }
            dateLabel.text = dateFormatter.string(from: saveDate)
        } else {
            dateLabel.text = "No date"
        }
        
        
        
        
        
        saveButton.isHidden = true
        editNameTextF.isHidden = true
        editAddressTextF.isHidden = true
        captionTextView.isEditable = false
        editDateTextField.isHidden = true
        captionTextView.backgroundColor = .clear
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        entry.setValue(captionTextView.text, forKey: "caption")
        entry.setValue(editNameTextF.text, forKey: "name")
        entry.setValue(editAddressTextF.text, forKey: "address")
        
        navigationItem.title = entry.name
        
        if newDate != nil {
            entry.setValue(newDate, forKey: "date")
        } else {
            guard let saveDate = entry.date else { return }
            entry.setValue(saveDate, forKey: "date")
        }
        do {
            try context.save()
        } catch {
            print("Error saving")
        }
        
    }
    
}
