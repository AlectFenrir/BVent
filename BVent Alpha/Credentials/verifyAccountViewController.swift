//
//  verifyAccountViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 01/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth

class verifyAccountViewController: UIViewController {
    
    var verifyAccountActivityIndicator: UIActivityIndicatorView!
    let loadingTextLabel = UILabel()

    override func viewDidLoad() {
        verifyAccountActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        verifyAccountActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        verifyAccountActivityIndicator.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        verifyAccountActivityIndicator.hidesWhenStopped = true
        verifyAccountActivityIndicator.isHidden = true
        verifyAccountActivityIndicator.center = view.center
        self.view.addSubview(verifyAccountActivityIndicator)
        
        loadingTextLabel.textColor = UIColor.white
        loadingTextLabel.text = "Verifying"
        loadingTextLabel.font = UIFont(name: "Helvetica Neue Bold", size: 30)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: verifyAccountActivityIndicator.center.x, y: verifyAccountActivityIndicator.center.y + 40)
        loadingTextLabel.isHidden = true
        self.view.addSubview(loadingTextLabel)
        
        super.viewDidLoad()
        
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
        self.show(vc, sender: nil)
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error signing up", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func verifiedButton(_ sender: Any) {
        verifyAccountActivityIndicator.isHidden = false
        verifyAccountActivityIndicator.startAnimating()
        
        loadingTextLabel.isHidden = false
        
        User.checkUserVerification { (status) in
            if status == true {
                self.pushTomainView()
            }
            else {
                if let user = Auth.auth().currentUser {
                    if !user.isEmailVerified{
                        let alertVC = UIAlertController(title: "Verify", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to your email?", preferredStyle: .alert)
                        let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                            (_) in
                            user.sendEmailVerification(completion: nil)
                        }
                        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                        
                        alertVC.addAction(alertActionOkay)
                        alertVC.addAction(alertActionCancel)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                    else {
                        print ("Email verified. Signing in...")
                        self.pushTomainView()
                    }
                }
            }
        }
    }
    

}
