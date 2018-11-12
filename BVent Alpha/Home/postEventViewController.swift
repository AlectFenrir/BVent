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

class postEventViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var categories: UITextField!
    let categoryPickerVal = ["Business", "Technology", "Economy", "Lifestyle", "Design", "Music", "More"]
    var categoryPicker = UIPickerView()
    @IBOutlet weak var eventTitleField: UITextField!
    @IBOutlet weak var eventPriceField: UITextField!
    @IBOutlet weak var eventDateField: UITextField!
    let datePicker = UIDatePicker()
    @IBOutlet weak var eventLocationField: UITextField!
    @IBOutlet weak var eventDescriptionField: UITextField!
    @IBOutlet weak var eventDesc: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var chooseImage: UIButton!
    var imagePicker: UIImagePickerController!
    
    var tanggal: String = ""
    
    var ref: DatabaseReference?
    
    var loggedInUser: AnyObject?
    
    var postActivityIndicator: UIActivityIndicatorView!
    let loadingTextLabel = UILabel()
    
    let notificationCenter = NotificationCenter.default
    
    //var tableView = rumahViewController.tableView
    
    //var pickerData:[String] = [String]()
    
    override func viewDidLoad() {
        postActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        postActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        postActivityIndicator.hidesWhenStopped = true
        postActivityIndicator.isHidden = true
        postActivityIndicator.center = view.center
        self.view.addSubview(postActivityIndicator)
        
        super.viewDidLoad()
        
        createCategoryPicker()
        createDatePicker()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
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
        
        categories.delegate = self
        eventTitleField.delegate = self
        eventPriceField.delegate = self
        eventDateField.delegate = self
        eventLocationField.delegate = self
        
        self.notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == NSNotification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer)  {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == categories {
            eventTitleField.becomeFirstResponder()
        }
        if textField == eventTitleField {
            eventPriceField.becomeFirstResponder()
        }
        if textField == eventPriceField {
            eventDateField.becomeFirstResponder()
        }
        if textField == eventDateField {
            eventLocationField.resignFirstResponder()
        }
        
        return true
    }
    
    func createDatePicker(){
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = NSLocale.init(localeIdentifier: "en_ID") as Locale
        eventDateField.inputView = datePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        //let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector (doneClicked))
        
        toolbar.setItems([/*cancelButton, */spaceButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        eventDateField.inputAccessoryView = toolbar
    }
    
    func createCategoryPicker() {
        
        categoryPicker.backgroundColor = UIColor(red: 207/255, green: 212/255, blue: 218/255, alpha: 1)
        categories.inputView = categoryPicker
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector (categoryDoneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector (categoryDoneClicked))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        categories.inputAccessoryView = toolBar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryPickerVal.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryPickerVal[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categories.text = categoryPickerVal[row]
    }
    
    @objc func categoryDoneClicked() {
        categories.inputView = categoryPicker
        self.view.endEditing(true)
    }
    
    @objc func doneClicked() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_ID")
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00")
        //eventDateField.text = dateFormatter.string(from: datePicker.date)
        //self.view.endEditing(true)
        tanggal = "\(dateFormatter.string(from: datePicker.date))"
        eventDateField.text = String(tanggal.prefix(16))
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
    
    //    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    //        self.categories.isHidden = true
    //        self.pickerCategories.isHidden = false;
    //        return false
    //    }
    
    @IBAction func eventPost(_ sender: UIButton) {
        
        postActivityIndicator.isHidden = false
        postActivityIndicator.startAnimating()
        
        loadingTextLabel.textColor = UIColor.black
        loadingTextLabel.text = "Posting"
        loadingTextLabel.font = UIFont(name: "Avenir Light", size: 20)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: postActivityIndicator.center.x, y: postActivityIndicator.center.y + 30)
        self.view.addSubview(loadingTextLabel)
        
        ref = Database.database().reference()
        self.loggedInUser = Auth.auth().currentUser
        
        
        uploadMedia() { url in
            if url != nil {
                self.ref?.child("posts").childByAutoId().setValue([
                    "category": self.categories.text!,
                    "title": self.eventTitleField.text!,
                    "price": self.eventPriceField.text!,
                    "date": self.tanggal,
                    "location": self.eventLocationField.text!,
                    "desc": self.eventDesc.text!,
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
                    "poster": self.loggedInUser!.uid!,
                    "imageUrl": url!,
                    //"postId": String(self.ref!.childByAutoId().key)
                    ] as [String: Any])
                
                print("Post Success!")
                self.postActivityIndicator.stopAnimating()
                self.postActivityIndicator.isHidden = true
                _ = self.navigationController?.popViewController(animated: true)
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
        
        /*if let uploadData = UIImagePNGRepresentation(self.eventImage.image!)*/ if let uploadData = UIImageJPEGRepresentation(self.eventImage.image!, 0.2) {
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
