//
//  detail1ViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 26/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication

class detail1ViewController: UIViewController {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var isi: UILabel!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var tempat: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var jam: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var enrollBtn: UIButton!
    @IBOutlet weak var decsBtn: UITextView!
    @IBOutlet weak var detail1ImageLoader: UIActivityIndicatorView!
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    var data: [kumpulanData] = kumpulanData.fetch()
    
    var pake: [kumpulanData] = []
    
    var index: Int?
    
    var phoneNumber: String = ""
    
    var ref: DatabaseReference!
    
    var val = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        val = false
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
        pake = data
        
        self.title = pake[index!].title
        
        //foto.image = pake[index!].image
        
        detail1ImageLoader.startAnimating()
        
        let url = URL(string: pake[index!].imageUrl)
        ImageService.getImage(withURL: url!) { (image) in
            self.foto.image = image
            
            self.detail1ImageLoader.stopAnimating()
            self.detail1ImageLoader.hidesWhenStopped = true
        }
        
        //time.text = pake[index!].cdown
        
        if (pake[index!].price == ""){
            price.text = "Free"
        }
        else{
            price.text = "Rp. \(pake[index!].price)"
        }
        
        category.text = "in \(pake[index!].category)"
        isi.text = pake[index!].desc
        tempat.text = "Place: \(pake[index!].location)"
        waktu.text = "Date: \(pake[index!].date)"
        jam.text = "Time: \(pake[index!].time)"
        
        if (pake[index!].benefit != ""){
            
            if (pake[index!].certification == true){
                benefit.text = "Benefits: \(pake[index!].benefit), Certificate"
            }
            else{
                benefit.text = "Benefit: \(pake[index!].benefit)"
            }
            
        }
        else{
            
            if (pake[index!].certification == true){
                benefit.text = "Benefit: Certificate"
            }
            else{
                benefit.text = ""
            }
        }
        
        
        
        phoneNumber = pake[index!].cp
        
        saveBtn.layer.cornerRadius = 7
        saveBtn.clipsToBounds = true
        saveBtn.layer.borderWidth = 0.25
        saveBtn.layer.borderColor = UIColor.black.cgColor
        
        enrollBtn.layer.cornerRadius = 7
        enrollBtn.clipsToBounds = true
        enrollBtn.layer.borderWidth = 0.25
        enrollBtn.layer.borderColor = UIColor.black.cgColor
        
        decsBtn.layer.cornerRadius = 7
        decsBtn.clipsToBounds = true
        decsBtn.layer.borderWidth = 0.25
        decsBtn.layer.borderColor = UIColor.white.cgColor
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func message(_ sender: Any) {
        UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func enroll(_ sender: UIButton) {
        
        self.ref = Database.database().reference()
        let userID = Auth.auth().currentUser
        
        let context = LAContext()
        var error: NSError?
        context.localizedFallbackTitle = "Use Passcode"
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.ref.child("users").child("regular").child(userID!.uid).child("enroll").observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            let value = snapshot.value as? NSDictionary
                            
                            if (snapshot.exists()){
                                
                                for postId in (value?.allKeys)!{
                                    
                                    if (self.pake[self.index!].postId == postId as! String){
                                        self.val = true
                                    }
                                    
                                }
                                
                                if (self.val == true){
                                    
                                    let alert = UIAlertController(title: "You've been enrolled!", message: nil, preferredStyle: .alert)
                                    
                                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                                    
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                else{
                                    self.ref.child("users").child("regular").child(userID!.uid).child("enroll").child(self.pake[self.index!].postId).setValue(true)
                                    self.ref?.child("posts").child(self.pake[self.index!].postId).child("attendees").child(userID!.uid).setValue(true)
                                    
                                    let alert = UIAlertController(title: "Enrolled!", message: nil, preferredStyle: .alert)
                                    
                                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                                    
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                
                            }
                            else{
                                self.ref.child("users").child("regular").child(userID!.uid).child("enroll").child(self.pake[self.index!].postId).setValue(true)
                                self.ref?.child("posts").child(self.pake[self.index!].postId).child("attendees").child(userID!.uid).setValue(true)
                                
                                let alert = UIAlertController(title: "Enrolled!", message: nil, preferredStyle: .alert)
                                
                                let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                                
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                            //let username = value?["username"] as? String ?? ""
                            
                            // ...
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        self.ref = Database.database().reference()
        let userID = Auth.auth().currentUser
        
        ref.child("users").child("regular").child(userID!.uid).child("bookmark").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys)!{
                    
                    if (self.pake[self.index!].postId == postId as! String){
                        self.val = true
                    }
                    
                }
                
                if (self.val == true){
                    
                    let alert = UIAlertController(title: "The Post Is Saved Already!", message: nil, preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else{
                    self.ref.child("users").child("regular").child(userID!.uid).child("bookmark").child(self.pake[self.index!].postId).setValue(true)
                    
                    let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else{
                self.ref.child("users").child("regular").child(userID!.uid).child("bookmark").child(self.pake[self.index!].postId).setValue(true)
                
                let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
            //let username = value?["username"] as? String ?? ""
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func previewActionItems() -> [UIPreviewActionItem] {
        
        let Share = UIPreviewAction(title: "Share", style: .default) { (action, viewController) -> Void in
            
            let alert3 = UIAlertController(title: "This Feature Is Not Ready Yet!", message: nil, preferredStyle: .alert)
            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert3.addAction(action3)
            self.present(alert3, animated: true, completion: nil)
        }
        
        return [Share]
        
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
