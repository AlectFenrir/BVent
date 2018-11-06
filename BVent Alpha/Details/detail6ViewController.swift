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
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        fetchData()
    //    }
    
    //    func fetchData()
    //    {
    //        do
    //        {
    //            SATPoint = try context.fetch(Enroll.fetchRequest())
    //            filteredData = SATPoint
    //            DispatchQueue.main.async {
    //
    //            }
    //        }
    //        catch
    //        {
    //            print("Couldn't Fetch Data")
    //        }
    //    }
    
    @IBAction func confirmAttendance(_ sender: UIButton) {
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        //        let customViewController: ongoingViewController = ongoingViewController(nibName: nil, bundle: nil)
        //        let ongoingTable2 = customViewController.ongoingTable
        self.ref.child("users").child("regular").child(userID!).child("enroll").child(postId!).setValue(false)
        
        _ = self.navigationController?.popViewController(animated: true)
        
        
        //        if (self.validation == false){
        //            let alert = UIAlertController(title: "Verification Code", message: nil, preferredStyle: .alert)
        //            alert.addTextField { (textField) in
        //                textField.placeholder = "Code"
        //            }
        //
        //
        //            let action = UIAlertAction(title: "Confirm", style: .default) { (_) in
        //
        //                if alert.textFields!.first!.text! == self.pake[self.index!].confirmCode{
        //
        //                    //if (self.validation == false)
        //
        //                    point = point + self.pake[self.index!].sat
        //                    //print(point)
        //
        //                    let alert1 = UIAlertController(title: "Verified!", message: nil, preferredStyle: .alert)
        //
        //                    let action1 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
        //
        //                    alert1.addAction(action1)
        //                    self.present(alert1, animated: true, completion: nil)
        //
        //                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Enroll")
        //
        //                    let predicate = NSPredicate(format: "done = '\(false)'")
        //                    fetchRequest.predicate = predicate
        //                    do
        //                    {
        //                        let test = try self.context.fetch(fetchRequest)
        //                        if test.count == 1
        //                        {
        //                            let objectUpdate = test[0] as! NSManagedObject
        //                            objectUpdate.setValue(true, forKey: "done")
        //                            do{
        //                                try self.context.save()
        //                            }
        //                            catch
        //                            {
        //                                print(error)
        //                            }
        //                        }
        //                    }
        //                    catch
        //                    {
        //                        print(error)
        //                    }
        //
        //                    self.pake[self.index!].enroll = true
        //                    self.validation = true
        //
        //                }
        //                else{
        //                    let alert2 = UIAlertController(title: "Wrong Code!!", message: nil, preferredStyle: .alert)
        //
        //                    let action2 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
        //
        //                    alert2.addAction(action2)
        //                    self.present(alert2, animated: true, completion: nil)
        //                    self.validation = false
        //                }
        //
        //            }
        //            alert.addAction(action)
        //            present(alert, animated: true, completion: nil)
        //
        //            //deleteIndex = index
        //            performSegue(withIdentifier: "delete", sender: nil)
        //        }
        //        else{
        //            //print("BEGO")
        //
        //            let alert3 = UIAlertController(title: "You've verified already!", message: nil, preferredStyle: .alert)
        //            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
        //
        //            alert3.addAction(action3)
        //            self.present(alert3, animated: true, completion: nil)
        //
        //        }
        
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let identifier = segue.identifier{
    //            if identifier == "delete"{
    //                let destination = segue.destination as! ongoingViewController
    //                //destination.deleteIndex = self.deleteIndex
    //            }
    //        }
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

