//
//  forgotPasswordViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 09/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class forgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField3: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var resetNowActivityIndicator: UIActivityIndicatorView!
    let loadingTextLabel = UILabel()
    
    let notificationCenter = NotificationCenter.default
    
    @IBAction func resetPassword(_ sender: Any) {
        resetNowActivityIndicator.isHidden = false
        resetNowActivityIndicator.startAnimating()
        
        loadingTextLabel.isHidden = false
        
        Auth.auth().sendPasswordReset(withEmail: emailField3.text!, completion: { (error) in
            //Make sure you execute the following code on the main queue
            DispatchQueue.main.async {
                //Use "if let" to access the error, if it is non-nil
                if let error = error {
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: error.localizedDescription, preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                } else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
                self.resetNowActivityIndicator.stopAnimating()
                self.resetNowActivityIndicator.isHidden = true
                self.loadingTextLabel.isHidden = true
            }
        })
    }
    
    override func viewDidLoad() {
        resetNowActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        resetNowActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        resetNowActivityIndicator.hidesWhenStopped = true
        resetNowActivityIndicator.isHidden = true
        resetNowActivityIndicator.center = view.center
        self.view.addSubview(resetNowActivityIndicator)
        
        loadingTextLabel.textColor = UIColor.black
        loadingTextLabel.text = "Resetting"
        loadingTextLabel.font = UIFont(name: "Helvetica Neue Bold", size: 20)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: resetNowActivityIndicator.center.x, y: resetNowActivityIndicator.center.y + 30)
        loadingTextLabel.isHidden = true
        self.view.addSubview(loadingTextLabel)
        
        super.viewDidLoad()
        emailField3.delegate = self
        emailField3.keyboardType = UIKeyboardType.emailAddress
        emailField3.underlined()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField3 {
            emailField3.resignFirstResponder()
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
