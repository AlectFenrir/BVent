//
//  signUpViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 07/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import Firebase
import FirebaseAuth

class signUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    @IBAction func signUp(_ sender: UIButton) {
        
        guard let fullname = fullNameField.text else { return }
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        guard let image = profileImageView.image else { return }
        guard let phoneNumber = phoneNumberField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: pass)
        {
            user, error in
            if error == nil && user != nil
            {
                print("User created!")
                
                self.uploadProfileImage(image)
                { url in
                    
                    if url != nil
                    {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = fullname
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil
                            {
                                print("User display name changed!")
                                
                                self.saveProfile(fullname: fullname, phoneNumber: phoneNumber, email: email, profileImageURL: url!)
                                { success in
                                    
                                    if success
                                    {
                                        self.dismiss(animated: true, completion: nil)
                                        
                                        //                                        let defaults = UserDefaults.standard
                                        //                                        defaults.setValue(true, forKey: "signUp")
                                        //                                        defaults.synchronize()
                                        //
                                        //
                                        //                                        let nextView: UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "chooseInterest"))!
                                        //
                                        //                                        let appdelegate = UIApplication.shared.delegate as! AppDelegate
                                        //
                                        //                                        appdelegate.window!.rootViewController = nextView
                                    }
                                    else
                                    {
                                        self.resetForm()
                                    }
                                }
                            }
                            else
                            {
                                print("Error: \(error!.localizedDescription)")
                                self.resetForm()
                            }
                        }
                    }
                    else
                    {
                        self.resetForm()
                    }
                }
            }
            else
            {
                print("User already exist!: \(error!.localizedDescription)")
                self.resetForm()
            }
        }
    }
    //var users: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullNameField.delegate = self
        emailField.delegate = self
        phoneNumberField.delegate = self
        passwordField.delegate = self
        fullNameField.keyboardType = UIKeyboardType.alphabet
        emailField.keyboardType = UIKeyboardType.emailAddress
        phoneNumberField.keyboardType = UIKeyboardType.numberPad
        passwordField.keyboardType = UIKeyboardType.alphabet
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        //signUp.layer.cornerRadius = 7
        //signUp.layer.masksToBounds = true
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameField {
            emailField.becomeFirstResponder()
        }
        if textField == emailField {
            phoneNumberField.becomeFirstResponder()
        }
        if textField == phoneNumberField {
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            passwordField.resignFirstResponder()
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
    
    @objc func didTapView(gesture: UITapGestureRecognizer)  {
        view.endEditing(true)
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
    
    func resetForm() {
        let alert = UIAlertController(title: "Error signing up", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let storageRef = Storage.storage().reference().child("users/regular/\(uid)/profileImage")
        
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
    
    func saveProfile(fullname:String, phoneNumber:String, email:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/regular/\(uid)/profile")
        
        let userObject = [
            "fullname": fullname,
            "phoneNumber": phoneNumber,
            "email": email,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    
}


extension signUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
