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
   
    @IBOutlet weak var pictureCaptionTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageTap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        restaurantImage.addGestureRecognizer(imageTap)
        
        
        restaurantImage.layer.borderColor = UIColor.black.cgColor
        restaurantImage.layer.borderWidth = 2
        
        pictureCaptionTextView.textColor = .lightGray
        pictureCaptionTextView.text = "Write a caption..."
        
        
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

}

extension NewEntryTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
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
            pictureCaptionTextView.isScrollEnabled = false
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if pictureCaptionTextView.text.isEmpty || pictureCaptionTextView.text == "" {
            pictureCaptionTextView.textColor = .lightGray
            pictureCaptionTextView.text = "Write a caption..."
        }
    }
    
}
