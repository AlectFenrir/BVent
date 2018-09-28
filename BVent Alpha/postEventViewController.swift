//
//  postEventViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 02/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import Firebase

class postEventViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var categories: UITextField!
    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var eventPriceField: UITextField!
    @IBOutlet weak var eventDateField: UITextField!
    let datePicker = UIDatePicker()
    @IBOutlet weak var eventLocationField: UITextField!
    @IBOutlet weak var eventDescriptionField: UITextField!
    
    @IBOutlet weak var chooseImage: UIButton!
    var imagePicker: UIImagePickerController!
    
    var ref: DatabaseReference?
    
    //var tableView = rumahViewController.tableView
    
    //var pickerData:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        eventImage.isUserInteractionEnabled = true
        eventImage.addGestureRecognizer(imageTap)
        eventImage.layer.cornerRadius = eventImage.bounds.height / 4
        eventImage.clipsToBounds = true
        //chooseImage.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        //pickerCategories.isHidden = true;
        //categories.text = "A4";
        
        //self.categories.delegate = self
        //self.pickerCategories.delegate = self
        //self.pickerCategories.dataSource = self
        
        //pickerData = ["A0","A1","A2","A3","A4","A5","A6","A7","A8","A9","A10"]
    }
    func createDatePicker(){
        
        datePicker.datePickerMode = .dateAndTime
        eventDateField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (doneClicked))
        toolbar.setItems([doneButton], animated: true)
        eventDateField.inputAccessoryView = toolbar
    }
    @objc func doneClicked()  {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        eventDateField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        eventDateField.text = "\(datePicker.date)"
        self.view.endEditing(true)
    }
    
    
    @IBAction func chooseImage(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
    
    
    //    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    //        self.categories.isHidden = true
    //        self.pickerCategories.isHidden = false;
    //        return false
    //    }
    
    @IBAction func eventPost(_ sender: UIButton) {
        
        
        ref = Database.database().reference()
        
        
        uploadMedia() { url in
            if url != nil {
                self.ref?.child("posts").childByAutoId().setValue([
                    "category": self.categories.text!,
                    "title": self.eventTitleField.text!,
                    "price": self.eventPriceField.text!,
                    "date": self.eventDateField.text!,
                    "location": self.eventLocationField.text!,
                    "desc": "HELLO",
//                    "desc": self.eventDescriptionField.text!,
                    "benefit": "3 SAT Points",
                    "bookmark": false,
                    "confirmCode": "qwerty",
                    "cp": "081282311233",
                    "done": false,
                    "enroll": false,
                    "sat": 3,
                    "certification": true,
                    "time": "09.00 - 10.00",
                    "timestamp": "\(Date().timeIntervalSince1970)",
                    "poster": "poster",
                    "imageUrl": url!
                    ] as [String: Any])
                
                print("Post Success!")
            }
        }
        
    }
    
    
    //var events: [NSManagedObject] = []
    
    
    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let key = self.ref?.child("posts").childByAutoId().key
        
        let storageRef = Storage.storage().reference().child("posts/\(uid)/\(key)")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        /*if let uploadData = UIImagePNGRepresentation(self.eventImage.image!)*/ if let uploadData = UIImageJPEGRepresentation(self.eventImage.image!, 0.5) {
            storageRef.putData(uploadData, metadata: metaData) { (metaData, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion((metaData?.downloadURL()?.absoluteString)!)
                    // your uploaded photo url.
                }
            }
        }
    }
    
    
    func uploadEventImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference().child("post/\(uid)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                if let url = metaData?.downloadURL() {
                    completion(url)
                } else {
                    completion(nil)
                }
                // success!
            } else {
                // failed
                completion(nil)
            }
        }
    }
    
    func saveProfile(fullname:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "fullname": fullname,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension postEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        eventImage.image = image
        
        picker.dismiss(animated: true, completion: nil )
        
    }
    
    
}
