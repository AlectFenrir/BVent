//
//  signInViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 07/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class signInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailField2: UITextField!
    @IBOutlet weak var passwordField2: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var signIn: UIButton!
    
    //var
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let email2 = emailField2.text else {return}
        guard let password2 = passwordField2.text else {return}
        
        Auth.auth().signIn(withEmail: email2, password: password2) { user, error in
            if error == nil && user != nil {
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                
                self.resetForm()
            }
        }
        
        //        Auth.auth().signIn(withEmail: email2, password: password2, completion: {
        //            user, error in
        //
        //            if error != nil{
        //                AlertController.showAlert(inViewController: self, title: "Error Signing In", message: error!.localizedDescription)
        //                return
        //            }
        //            else{
        //                AlertController.showAlert(inViewController: self, title: "Signed In", message: "Sign in success")
        //                return
        //
        //            }
        //        })
        
        //        let defaults = UserDefaults.standard
        //        defaults.setValue(true, forKey: "SignIn")
        //        defaults.synchronize()
        //
        //
        //
        //        let nextView: UITabBarController = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
        //
        //        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        //
        //        appdelegate.window!.rootViewController = nextView
        
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //let newPoint = Sat(context: context)
        //newPoint.point = 0
    }
    
    @objc func handleSignIn() {
        guard let email = emailField2.text else { return }
        guard let pass = passwordField2.text else { return }
        
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                self.dismiss(animated: false, completion: nil)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
                
                self.resetForm()
            }
        }
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error logging in", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //    func signIn(){
    //        Auth.auth().signIn(withEmail: emailField2.text!, password: passwordField2.text!, completion: {
    //            user, error in
    //
    //            if error != nil{
    //                print("Incorrect!")
    //            }
    //            else{
    //                print("Success! ")
    //            }
    //
    //        })
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField2.delegate = self
        passwordField2.delegate = self
        
        emailField2.keyboardType = UIKeyboardType.emailAddress
        passwordField2.keyboardType = UIKeyboardType.alphabet
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        //signIn().layer.cornerRadius = 7
        //signIn().layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField2{
            passwordField2.becomeFirstResponder()
        }
        if textField == passwordField2{
            passwordField2.resignFirstResponder()
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
