//
//  detail5ViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 03/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Firebase
import LocalAuthentication

class detail6ViewController: UIViewController {
    
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var tempat: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var jam: UILabel!
    @IBOutlet weak var isi: UILabel!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var detail6ImageLoader: UIActivityIndicatorView!
    
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
    
    var video = AVCaptureVideoPreviewLayer()
    
    var deleteIndex: Int?
    var validation: Bool = false
    
    var ref: DatabaseReference!
    
    var pake: kumpulanData!
    
    //var point: sat = sat.fetch()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //    var SATPoint: [Enroll] = []
    //    var sat: Sat?
    //    var filteredData: [Enroll] = []
    
    var finalPoint: Int = 0
    
    var data: [kumpulanData] = kumpulanData.fetch()
    var categ: String?
    var postId: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        ref.child("posts").child(postId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value2 = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            self.pake = kumpulanData.init(benefit: value2?["benefit"] as? String ?? "", bookmark: value2?["bookmark"] as? Bool ?? false, category: value2?["category"] as? String ?? "", certification: value2?["certification"] as? Bool ?? false, confirmCode: value2?["confirmCode"] as? String ?? "", cp: value2?["cp"] as? String ?? "", date: value2?["date"] as? String ?? "", desc: value2?["desc"] as? String ?? "", done: value2?["done"] as? Bool ?? false, enroll: value2?["enroll"] as? Bool ?? false, location: value2?["location"] as? String ?? "", price: value2?["price"] as? String ?? "", sat: value2?["sat"] as? Int ?? 0, time: value2?["time"] as? String ?? "", title: value2?["title"] as? String ?? "", timestamp: value2?["timestamp"] as? String ?? "", poster: value2?["poster"] as? String ?? "", imageUrl: value2?["imageUrl"] as? String ?? "", postId: self.postId!)
            
            self.title = self.pake.title
            
            self.detail6ImageLoader.startAnimating()
            
            let url = URL(string: self.pake.imageUrl)
            ImageService.getImage(withURL: url!) { (image) in
                self.foto.image = image
                
                self.detail6ImageLoader.stopAnimating()
                self.detail6ImageLoader.hidesWhenStopped = true
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
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func message(_ sender: Any) {
        UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func confirmAttendance(_ sender: UIButton) {
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let context = LAContext()
        var error: NSError?
        context.localizedFallbackTitle = "Use Passcode"
        
        //        let customViewController: ongoingViewController = ongoingViewController(nibName: nil, bundle: nil)
        //        let ongoingTable2 = customViewController.ongoingTable
        
        
        if (self.validation == false) {
            //            let alert = UIAlertController(title: "Verification Code", message: nil, preferredStyle: .alert)
            //            alert.addTextField { (textField) in
            //                textField.placeholder = "Code"
            //            }
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                    [unowned self] success, authenticationError in
                    
                    DispatchQueue.main.async {
                        if success {
                            
                            let alert1 = UIAlertController(title: "Verified!", message: nil, preferredStyle: .alert)
                            
                            point = point + self.pake.sat
                            print(point)
                            
                            let action1 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
                            
                            alert1.addAction(action1)
                            self.present(alert1, animated: true, completion: nil)
                            
                            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Enroll")
                            
                            let predicate = NSPredicate(format: "done = '\(false)'")
                            fetchRequest.predicate = predicate
                            do
                            {
                                let test = try self.context.fetch(fetchRequest)
                                if test.count == 1
                                {
                                    let objectUpdate = test[0] as! NSManagedObject
                                    objectUpdate.setValue(true, forKey: "done")
                                    do{
                                        try self.context.save()
                                    }
                                    catch
                                    {
                                        print(error)
                                    }
                                }
                            }
                            catch
                            {
                                print(error)
                            }
                            
                            self.pake.enroll = true
                            self.validation = true
                            
                            self.ref.child("users").child("regular").child(userID!).child("enroll").child(self.postId!).setValue(false)
                            
                            _ = self.navigationController?.popViewController(animated: true)
                            
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
            
  
        } else {
            //print("BEGO")
            
            let alert3 = UIAlertController(title: "You've verified already!", message: nil, preferredStyle: .alert)
            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert3.addAction(action3)
            self.present(alert3, animated: true, completion: nil)
            
        }
        
    }
    
}

