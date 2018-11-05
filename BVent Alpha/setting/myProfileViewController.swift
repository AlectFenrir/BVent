//
//  myProfileViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 10/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class myProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var himaBinus: UIImageView!
    @IBOutlet weak var himaBinusButton: UIButton!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var SATPoint: UILabel!
    @IBOutlet weak var accountEmail: UILabel!
    @IBOutlet weak var accountPhoneNumber: UILabel!
    @IBOutlet weak var accountProfilePicture: UIImageView!
    @IBOutlet weak var myProfileImageLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var eTicketCell: UICollectionView!
    
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
    
    //var loggedInUser: AnyObject?
    //var databaseRef = Database.database().reference()
    //var storageRef = Storage.storage().reference()
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    var postId: String = ""
    var val: Bool = false
    
    @IBOutlet weak var btn: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user = [UserProfile]()
    
    //var fullnameArray = [String]()
    
    //var filteredData: [SignUp] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        val = false
        kumpulanData.ongoing.removeAll()
        
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        databaseRef.keepSynced(true)
        
        //self.loggedInUser = Auth.auth().currentUser
        let userID = Auth.auth().currentUser?.uid
        
        self.databaseRef.child("users").child("regular").child(userID!).child("profile").queryLimited(toLast: 10).observe(.value, with: { (snapshot) in
            let snapshot = snapshot.value as! [String: AnyObject]
            self.accountName.text = snapshot["fullname"] as? String
            //self.accountPhoneNumber.text = snapshot["phoneNumber"] as? String
            //self.accountEmail.text = snapshot["email"] as? String
            
            let databaseProfilePic = snapshot["photoURL"] as! String
            
            self.myProfileImageLoader.startAnimating()
            self.myProfileImageLoader.color = UIColor.white
            
            let url = URL(string: databaseProfilePic)
            
            ImageService.getImage(withURL: url!) { (image) in
                self.setProfilePicture(self.accountProfilePicture, imageToSet: image!)
                
                self.myProfileImageLoader.stopAnimating()
                self.myProfileImageLoader.hidesWhenStopped = true
            }
            
//            let data = try? Data(contentsOf: URL(string: databaseProfilePic)!)
//
//            self.setProfilePicture(self.accountProfilePicture,imageToSet:UIImage(data:data!)!)
        })
        
        btn.layer.cornerRadius = 7
        btn.clipsToBounds = true
        btn.layer.borderWidth = 0.25
        btn.layer.borderColor = UIColor.black.cgColor
        
        self.databaseRef.child("users").child("regular").child(userID!).child("enroll").observe(.value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys)!{
                    
                    self.databaseRef.child("posts").child(postId as! String).observe(.value, with: { (snapshot2) in
                        // Get user value
                        let value2 = snapshot2.value as? NSDictionary
                        
                        kumpulanData.ongoing.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
                                                                 bookmark: value2?["bookmark"] as? Bool ?? false,
                                                                 category: value2?["category"] as? String ?? "",
                                                                 certification: value2?["certification"] as? Bool ?? false,
                                                                 confirmCode: value2?["confirmCode"] as? String ?? "",
                                                                 cp: value2?["cp"] as? String ?? "",
                                                                 date: value2?["date"] as? String ?? "",
                                                                 desc: value2?["desc"] as? String ?? "",
                                                                 done: value2?["done"] as? Bool ?? false,
                                                                 enroll: value2?["enroll"] as? Bool ?? false,
                                                                 location: value2?["location"] as? String ?? "",
                                                                 price: value2?["price"] as? String ?? "",
                                                                 sat: value2?["sat"] as? Int ?? 0,
                                                                 time: value2?["time"] as? String ?? "",
                                                                 title: value2?["title"] as? String ?? "",
                                                                 timestamp: value2?["timestamp"] as? String ?? "",
                                                                 poster: value2?["poster"] as? String ?? "",
                                                                 imageUrl: value2?["imageUrl"] as? String ?? "",
                                                                 postId: snapshot2.key))
                        
                        ongoingPake = kumpulanData.ongoing
                        
                        self.eTicketCell.reloadData()
                        //print("p")
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
            }
            else{
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        SATPoint.text = "Your SAT Point Is: \(point) from \(remainPoint)"
        
        //himaBinus.image = UIImage(named: "calendar")
        
        
        // Do any additional setup after loading the view.
    }
    
    //var users: [NSManagedObject] = []
    
    
    internal func setProfilePicture(_ imageView:UIImageView,imageToSet:UIImage)
    {
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ongoingPake.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = eTicketCell.dequeueReusableCell(withReuseIdentifier: "ticketCell", for: indexPath) as! eTicketCollectionViewCell
        
        cell.eTicketImageLoader.startAnimating()
        
        let url = URL(string: ongoingPake[indexPath.row].imageUrl)
        ImageService.getImage(withURL: url!) { (image) in
            cell.eTicketImage.image = image
            
            cell.eTicketImageLoader.stopAnimating()
            cell.eTicketImageLoader.hidesWhenStopped = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let userID = Auth.auth().currentUser?.uid
        databaseRef = Database.database().reference()
        databaseRef.keepSynced(true)
        databaseRef.child("users").child("regular").child(userID!).child("enroll").child(ongoingPake[indexPath.row].postId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.val = (snapshot.value as? Bool)!
            
            if (self.val == false){
                self.failed()
            }
            else{
                self.postId = ongoingPake[indexPath.row].postId
                self.success()
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func failed(){
        let alert = UIAlertController(title: "This Event is Done Already!", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func success(){
        performSegue(withIdentifier: "eTicketDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "eTicketDetails"{
                let destination = segue.destination as! detail5ViewController
                destination.postId = postId
            }
        }
        
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
