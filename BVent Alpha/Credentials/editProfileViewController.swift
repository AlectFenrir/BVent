//
//  editProfileViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 27/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class editProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameField4: UITextField!
    @IBOutlet weak var emailField4: UITextField!
    @IBOutlet weak var studentIDField4: UITextField!
    @IBOutlet weak var phoneNumberField4: UITextField!
    @IBOutlet weak var majorField: UITextField!
    @IBOutlet weak var universityField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    var editActivityIndicator: UIActivityIndicatorView!
    let loadingTextLabel = UILabel()
    
    var imagePicker: UIImagePickerController!
    @IBOutlet var inputFields: [UITextField]!
    
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        editActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        editActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        editActivityIndicator.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        editActivityIndicator.hidesWhenStopped = true
        editActivityIndicator.isHidden = true
        editActivityIndicator.center = view.center
        self.view.addSubview(editActivityIndicator)
        
        loadingTextLabel.textColor = UIColor.white
        loadingTextLabel.text = "Saving"
        loadingTextLabel.font = UIFont(name: "Helvetica Neue Bold", size: 30)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: editActivityIndicator.center.x, y: editActivityIndicator.center.y + 40)
        loadingTextLabel.isHidden = true
        self.view.addSubview(loadingTextLabel)
        
        super.viewDidLoad()
        
        fullNameField4.delegate = self
        //emailField4.delegate = self
        studentIDField4.delegate = self
        phoneNumberField4.delegate = self
        majorField.delegate = self
        universityField.delegate = self
        //passwordField.delegate = self
        
        fullNameField4.underlined()
        //emailField4.underlined()
        studentIDField4.underlined()
        phoneNumberField4.underlined()
        majorField.underlined()
        universityField.underlined()
        //passwordField.underlined()
        
        fullNameField4.keyboardType = UIKeyboardType.alphabet
        //emailField4.keyboardType = UIKeyboardType.emailAddress
        studentIDField4.keyboardType = UIKeyboardType.numberPad
        phoneNumberField4.keyboardType = UIKeyboardType.phonePad
        majorField.keyboardType = UIKeyboardType.alphabet
        universityField.keyboardType = UIKeyboardType.alphabet
        //passwordField.keyboardType = UIKeyboardType.alphabet
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        self.notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        // Do any additional setup after loading the view.
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
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
        if textField == fullNameField4{
            studentIDField4.becomeFirstResponder()
        }
//        if textField == emailField4{
//            studentIDField4.becomeFirstResponder()
//        }
        if textField == studentIDField4{
            phoneNumberField4.becomeFirstResponder()
        }
        if textField == phoneNumberField4{
            majorField.becomeFirstResponder()
        }
        if textField == majorField{
            universityField.becomeFirstResponder()
        }
        if textField == universityField{
            universityField.resignFirstResponder()
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        
        //        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        //            // ...
        //        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        
        //        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil){
            Notification in
            self.keyboardWillShow(notification: Notification)
        }
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil){
            notification in
            self.keyboardWillHIde(notification: notification)
        }
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error updating!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHIde(notification: Notification){
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func updateProfile(_ sender: Any) {
        editActivityIndicator.isHidden = false
        editActivityIndicator.startAnimating()
        
        loadingTextLabel.isHidden = false
        
        let userID = Auth.auth().currentUser?.uid
        let userRef = Database.database().reference().child("users").child("regular").child(userID!).child("profile")
        
        for item in self.inputFields {
            item.resignFirstResponder()
        }
        
        if ((fullNameField4.text != "" || phoneNumberField4.text != "" || universityField.text != "") && (fullNameField4.text != nil || phoneNumberField4.text != nil || universityField.text != nil)){
            
            if let new_profilePic = profileImageView.image {
                let storageRef = Storage.storage().reference().child("users").child("regular").child(userID!).child("profileImage")
                let imageData = UIImageJPEGRepresentation(new_profilePic, 0.5)
                _ = storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        guard let path = metadata else {
                            print("Error!")
                            return
                        }
                        storageRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                print(error!)
                            } else {
                                let imageURL = url!.absoluteString
                                print(imageURL)
                                let values = ["photoURL": imageURL]
                                Database.database().reference().child("users").child("regular").child((userID)!).child("profile").updateChildValues(values, withCompletionBlock: { (errr, _) in
                                    if errr == nil {
                                        print(errr?.localizedDescription as Any)
                                    }
                                })
                            }
                        })
                    }
                })
            }
            
//            if let new_profilePic = profileImageView.image {
//                let storageRef = Storage.storage().reference().child("users").child("regular").child(userID!).child("profileImage")
//                let imageData = UIImageJPEGRepresentation(new_profilePic, 0.5)
//                storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
//                    if err == nil {
//                        let path = metadata?.downloadURL()?.absoluteString
//                        let values = ["photoURL": path!]
//                        Database.database().reference().child("users").child("regular").child((userID)!).child("profile").updateChildValues(values, withCompletionBlock: { (errr, _) in
//                            if errr == nil {
//                                print(errr?.localizedDescription as Any)
//                            }
//                        })
//                    }
//                })
//            }
            
//            if let new_Email = emailField4.text, let new_password = passwordField.text{
//
//                Auth.auth().currentUser!.updateEmail(to: emailField4.text!); Auth.auth().currentUser!.updatePassword(to: passwordField.text!) { error in
//
//                    if error == nil{
//                        userRef.updateChildValues(["email" : new_Email], withCompletionBlock: {(errEM, referenceEM)   in
//
//                            if errEM == nil{
//                                let userInfo = ["email" : new_Email, "password" : new_password]
//                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
//                                print(referenceEM)
//                            }else{
//                                print(errEM?.localizedDescription as Any)
//                            }
//                        })
//                    }
//                    else {
//                        print("Error Updating Profile!")
//                    }
//                }
//            }
            
            if let new_Name = fullNameField4.text{
                
                userRef.updateChildValues(["fullname" : new_Name ], withCompletionBlock: {(errNM, referenceNM)   in
                    
                    if errNM == nil{
                        print(referenceNM)
                    }else{
                        print(errNM?.localizedDescription as Any)
                    }
                })
            }
            
            if let new_PhoneNumber = phoneNumberField4.text {
                userRef.updateChildValues(["phoneNumber" : new_PhoneNumber ], withCompletionBlock: {(errNM, referenceNM)   in
                    
                    if errNM == nil{
                        print(referenceNM)
                    }else{
                        print(errNM?.localizedDescription as Any)
                    }
                })
            }
            
            if let new_University = universityField.text {
                userRef.updateChildValues(["university" : new_University ], withCompletionBlock: {(errNM, referenceNM)   in
                    
                    if errNM == nil{
                        print(referenceNM)
                    }else{
                        print(errNM?.localizedDescription as Any)
                    }
                })
            }
            
        }
            
        else{
            
            print("Please fill in one or more of the missing text fields that you would like to update.")
            
        }
        
        if let new_studentID = studentIDField4.text {
            userRef.updateChildValues(["studentID" : new_studentID], withCompletionBlock: {(errNM, referenceNM)   in
                
                if errNM == nil{
                    print(referenceNM)
                }else{
                    print(errNM?.localizedDescription as Any)
                }
            })
        }
        
        if let new_major = majorField.text {
            userRef.updateChildValues(["major" : new_major], withCompletionBlock: {(errNM, referenceNM)   in
                
                if errNM == nil{
                    print(referenceNM)
                }else{
                    print(errNM?.localizedDescription as Any)
                }
            })
        }
        
        self.editActivityIndicator.stopAnimating()
        self.editActivityIndicator.isHidden = true
        self.loadingTextLabel.isHidden = true
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference().child("users/regular/\(uid)/profileImage")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                guard let path = metaData else {
                    print("Error!")
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        let imageURL = url!.absoluteString
                        print(imageURL)
                    }
                })
                // success!
            } else {
                // failed
                completion(nil)
            }
        }
    }
    
}

extension editProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profileImageView.image = pickedImage
        }

        picker.dismiss(animated: true, completion: nil)
    }


}
