//
//  NewEntryTableViewController.swift
//  Food Finder
//
//  Created by Will Chew on 2019-02-02.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import CoreData

class NewEntryTableViewController: UITableViewController {
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var pictureCaptionTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var visitDate: Date!
    let dateFormatter = DateFormatter()
    
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        
        dateTextField.text = dateFormatter.string(from: Date())
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        restaurantImage.addGestureRecognizer(imageTap)
        
        
        restaurantImage.layer.borderColor = UIColor.black.cgColor
        restaurantImage.layer.borderWidth = 2
        
        pictureCaptionTextView.textColor = .lightGray
        pictureCaptionTextView.text = "Write a caption..."
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = .date
        dateTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.view.addGestureRecognizer(tapGesture)
        
        self.navigationController?.navigationItem.title = "New Entry"
        
    }
    @objc func viewTapped() {
        self.view.endEditing(true)
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
       
        visitDate = sender.date
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    
    @objc func pickImage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "No camera detected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func openGallery(){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        
        let newEntry = Entry(context:self.context)
        newEntry.name = nameTextField.text
        if pictureCaptionTextView.text == "Write a caption..." {
            pictureCaptionTextView.text = ""
        } else {
        newEntry.caption = pictureCaptionTextView.text
        }
        newEntry.date = visitDate
        newEntry.address = addressTextField.text
        
        if let img = restaurantImage.image {
            let data = img.pngData() as Data?
            newEntry.image = data
        }
    
        
        print("Pressed")
        saveItems()
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
}

extension NewEntryTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            restaurantImage.contentMode = .scaleToFill
            restaurantImage.image = editedImage
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if pictureCaptionTextView.textColor == .lightGray && pictureCaptionTextView.isFirstResponder {
            pictureCaptionTextView.text = nil
            
            pictureCaptionTextView.textColor = .black
            pictureCaptionTextView.autocapitalizationType = .words
            
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if pictureCaptionTextView.text.isEmpty || pictureCaptionTextView.text == "" {
            pictureCaptionTextView.textColor = .lightGray
            pictureCaptionTextView.text = "Write a caption..."
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameTextField.text != "" {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
}
