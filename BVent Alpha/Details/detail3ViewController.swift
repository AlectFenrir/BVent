//
//  detail3ViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 26/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class detail3ViewController: UIViewController {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var isi: UILabel!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var tempat: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var jam: UILabel!
    @IBOutlet weak var detail3ImageLoader: UIActivityIndicatorView!
    
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
    
    var pake: kumpulanData!
    
    var pakes: [kumpulanData] = []
    
    var index: Int?
    
    var validation: Bool = false
    
    var ref: DatabaseReference!
    
    var postId: String?
    
    var val = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        ref.child("posts").child(postId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value2 = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            self.pake = kumpulanData.init(benefit: value2?["benefit"] as? String ?? "", bookmark: value2?["bookmark"] as? Bool ?? false, category: value2?["category"] as? String ?? "", certification: value2?["certification"] as? Bool ?? false, confirmCode: value2?["confirmCode"] as? String ?? "", cp: value2?["cp"] as? String ?? "", date: value2?["date"] as? String ?? "", desc: value2?["desc"] as? String ?? "", done: value2?["done"] as? Bool ?? false, enroll: value2?["enroll"] as? Bool ?? false, location: value2?["location"] as? String ?? "", price: value2?["price"] as? String ?? "", sat: value2?["sat"] as? Int ?? 0, time: value2?["time"] as? String ?? "", title: value2?["title"] as? String ?? "", timestamp: value2?["timestamp"] as? String ?? "", poster: value2?["poster"] as? String ?? "", imageUrl: value2?["imageUrl"] as? String ?? "", postId: self.postId!)
            
            self.title = self.pake.title
            
            self.detail3ImageLoader.startAnimating()
            
            let url = URL(string: self.pake.imageUrl)
            ImageService.getImage(withURL: url!) { (image) in
                self.foto.image = image
                
                self.detail3ImageLoader.stopAnimating()
                self.detail3ImageLoader.hidesWhenStopped = true
            }
            
            if (self.pake.price == ""){
                self.price.text = "Free"
            }
            else{
                self.price.text = "Rp. \(self.pake.price)"
            }
            
            self.category.text = "in \(self.pake.category)"
            self.isi.text = self.pake.desc
            self.tempat.text = "Place: \(self.pake.location)"
            self.waktu.text = "Date: \(self.pake.date)"
            self.jam.text = "Time: \(self.pake.time)"
            
            if (self.pake.benefit != ""){
                
                if (self.pake.certification == true){
                    self.benefit.text = "Benefits: \(self.pake.benefit), Certificate"
                }
                else{
                    self.benefit.text = "Benefit: \(self.pake.benefit)"
                }
                
            }
            else{
                
                if (self.pake.certification == true){
                    self.benefit.text = "Benefit: Certificate"
                }
                else{
                    self.benefit.text = ""
                }
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }

        
        // Do any additional setup after loading the view.
    }
    @IBAction func message(_ sender: Any) {
        UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func enroll(_ sender: UIButton) {
        
        self.ref = Database.database().reference()
        let userID = Auth.auth().currentUser
        
        ref.child("users").child("regular").child(userID!.uid).child("enroll").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys)!{
                    
                    if (self.postId == postId as! String){
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
                    self.ref.child("users").child("regular").child(userID!.uid).child("enroll").child(self.postId!).setValue(true)
                    self.ref?.child("posts").child(self.postId!).child("attendees").child(userID!.uid).setValue(true)
                    
                    let alert = UIAlertController(title: "Enrolled!", message: nil, preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else{
                self.ref.child("users").child("regular").child(userID!.uid).child("enroll").child(self.postId!).setValue(true)
                self.ref?.child("posts").child(self.postId!).child("attendees").child(userID!.uid).setValue(true)
                
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
