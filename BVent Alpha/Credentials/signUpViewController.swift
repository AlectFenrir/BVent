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
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
//    @IBOutlet weak var darkView: UIView!
//    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var signUpActivityIndicator: UIActivityIndicatorView!
    let loadingTextLabel = UILabel()
    
    var imagePicker: UIImagePickerController!
    @IBOutlet var inputFields: [UITextField]!
    //var waringLabels = "Wrong Input Password"
    
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        signUpActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        signUpActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        signUpActivityIndicator.hidesWhenStopped = true
        signUpActivityIndicator.isHidden = true
        signUpActivityIndicator.center = view.center
        self.view.addSubview(signUpActivityIndicator)
        
        loadingTextLabel.textColor = UIColor.black
        loadingTextLabel.text = "Signing Up"
        loadingTextLabel.font = UIFont(name: "Helvetica Neue Bold", size: 20)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: signUpActivityIndicator.center.x, y: signUpActivityIndicator.center.y + 30)
        loadingTextLabel.isHidden = true
        self.view.addSubview(loadingTextLabel)
        
        super.viewDidLoad()
        
        fullNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        fullNameField.keyboardType = UIKeyboardType.alphabet
        emailField.keyboardType = UIKeyboardType.emailAddress
        passwordField.keyboardType = UIKeyboardType.alphabet
        
        fullNameField.underlined()
        emailField.underlined()
        passwordField.underlined()
        
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        self.notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //signUp.layer.cornerRadius = 7
        //signUp.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        
//        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
//        profileImageView.isUserInteractionEnabled = true
//        profileImageView.addGestureRecognizer(imageTap)
//        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
//        profileImageView.clipsToBounds = true
//        tapToChangeProfileButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
//        imagePicker = UIImagePickerController()
//        imagePicker.allowsEditing = true
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.delegate = self
        
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
    
//    func showLoading(state: Bool)  {
//        if state {
//            self.darkView.isHidden = false
//            self.spinner.startAnimating()
//            UIView.animate(withDuration: 0.3, animations: {
//                self.darkView.alpha = 0.5
//            })
//        } else {
//            UIView.animate(withDuration: 0.3, animations: {
//                self.darkView.alpha = 0
//            }, completion: { _ in
//                self.spinner.stopAnimating()
//                self.darkView.isHidden = true
//            })
//        }
//    }
    
    func pushToVerifyView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "verifyAccountViewController") as! UIViewController
        self.show(vc, sender: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        signUpActivityIndicator.isHidden = false
        signUpActivityIndicator.startAnimating()
        
        loadingTextLabel.isHidden = false
        
        for item in self.inputFields {
            item.resignFirstResponder()
        }
        //self.showLoading(state: true)
        User.registerUser(withName: self.fullNameField.text!, email: self.emailField.text!, phoneNumber: "", password: self.passwordField.text!, profilePic: UIImage(named: "noun_34476")!, SAT: "0") { [weak weakSelf = self] (status) in
            DispatchQueue.main.async {
                //weakSelf?.showLoading(state: false)
                for item in self.inputFields {
                    item.text = ""
                }
                if status == true {
                    weakSelf?.pushToVerifyView()
                    //weakSelf?.profileImageView.image = UIImage.init(named: "ava3")
                } else {
                    self.resetForm()
                    print("Wrong Input Password!")
                    //                    for item in (weakSelf?.waringLabels)! {
                    //                        item.isHidden = false
                    //                    }
                }
                self.signUpActivityIndicator.stopAnimating()
                self.signUpActivityIndicator.isHidden = true
                self.loadingTextLabel.isHidden = true
            }
        }
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


//extension signUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            self.profileImageView.image = pickedImage
//        }
//
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//
//}
