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
