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
    
    @IBOutlet weak var myProfileScrollView: UIScrollView!
    @IBOutlet weak var himaBinus: UIImageView!
    @IBOutlet weak var himaBinusButton: UIButton!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var SATPoint: UILabel!
    @IBOutlet weak var accountEmail: UILabel!
    @IBOutlet weak var accountPhoneNumber: UILabel!
    @IBOutlet weak var accountProfilePicture: UIImageView!
    @IBOutlet weak var myProfileImageLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var eTicketCellController: UICollectionView!
    
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
    
    var tableView = UITableView()
    lazy var refreshControl: UIRefreshControl = {
        tableView.frame = view.frame
        
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Fetching My Profile Data", attributes: attributes)
        
        refreshControl.addTarget(self, action: #selector(myProfileViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = attributedTitle
        refreshControl.attributedTitle = NSAttributedString(string:"Last updated on " + NSDate().description)
        
        return refreshControl
    }()
    
    //var loggedInUser: AnyObject?
    //var databaseRef = Database.database().reference()
    //var storageRef = Storage.storage().reference()
    var ref: DatabaseReference!
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
        kumpulanData.eTicket.removeAll()
        
        ref = Database.database().reference()
        //storageRef = Storage.storage().reference()
        
        ref.keepSynced(true)
        
        //self.loggedInUser = Auth.auth().currentUser
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child("regular").child(userID!).child("profile").queryLimited(toLast: 10).observe(.value, with: { (snapshot) in
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
        
        ref.child("users").child("regular").child(userID!).child("enroll").observeSingleEvent(of: .value, with: { (snapshot2) in
            // Get user value
            let value2 = snapshot2.value as? NSDictionary

            if (snapshot2.exists()){

                for postId in (value2?.allKeys)!{

                    self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot3) in
                        // Get user value
                        let value3 = snapshot3.value as? NSDictionary

                        kumpulanData.eTicket.append(kumpulanData(benefit: value3?["benefit"] as? String ?? "",
                                                                 bookmark: value3?["bookmark"] as? Bool ?? false,
                                                                 category: value3?["category"] as? String ?? "",
                                                                 certification: value3?["certification"] as? Bool ?? false,
                                                                 confirmCode: value3?["confirmCode"] as? String ?? "",
                                                                 cp: value3?["cp"] as? String ?? "",
                                                                 date: value3?["date"] as? String ?? "",
                                                                 desc: value3?["desc"] as? String ?? "",
                                                                 done: value3?["done"] as? Bool ?? false,
                                                                 enroll: value3?["enroll"] as? Bool ?? false,
                                                                 location: value3?["location"] as? String ?? "",
                                                                 price: value3?["price"] as? String ?? "",
                                                                 sat: value3?["sat"] as? Int ?? 0,
                                                                 time: value3?["time"] as? String ?? "",
                                                                 title: value3?["title"] as? String ?? "",
                                                                 timestamp: value3?["timestamp"] as? String ?? "",
                                                                 poster: value3?["poster"] as? String ?? "",
                                                                 imageUrl: value3?["imageUrl"] as? String ?? "",
                                                                 postId: snapshot3.key))

                        eTicketPake = kumpulanData.eTicket

                        self.eTicketCellController.reloadData()
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
        
        self.view.addSubview(tableView)
        
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        val = false
        kumpulanData.eTicket.removeAll()
        
        ref = Database.database().reference()
        //storageRef = Storage.storage().reference()
        
        ref.keepSynced(true)
        
        //self.loggedInUser = Auth.auth().currentUser
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child("regular").child(userID!).child("profile").queryLimited(toLast: 10).observe(.value, with: { (snapshot) in
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
        
        ref.child("users").child("regular").child(userID!).child("enroll").observeSingleEvent(of: .value, with: { (snapshot2) in
            // Get user value
            let value2 = snapshot2.value as? NSDictionary
            
            if (snapshot2.exists()){
                
                for postId in (value2?.allKeys)!{
                    
                    self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot3) in
                        // Get user value
                        let value3 = snapshot3.value as? NSDictionary
                        
                        kumpulanData.eTicket.append(kumpulanData(benefit: value3?["benefit"] as? String ?? "",
                                                                 bookmark: value3?["bookmark"] as? Bool ?? false,
                                                                 category: value3?["category"] as? String ?? "",
                                                                 certification: value3?["certification"] as? Bool ?? false,
                                                                 confirmCode: value3?["confirmCode"] as? String ?? "",
                                                                 cp: value3?["cp"] as? String ?? "",
                                                                 date: value3?["date"] as? String ?? "",
                                                                 desc: value3?["desc"] as? String ?? "",
                                                                 done: value3?["done"] as? Bool ?? false,
                                                                 enroll: value3?["enroll"] as? Bool ?? false,
                                                                 location: value3?["location"] as? String ?? "",
                                                                 price: value3?["price"] as? String ?? "",
                                                                 sat: value3?["sat"] as? Int ?? 0,
                                                                 time: value3?["time"] as? String ?? "",
                                                                 title: value3?["title"] as? String ?? "",
                                                                 timestamp: value3?["timestamp"] as? String ?? "",
                                                                 poster: value3?["poster"] as? String ?? "",
                                                                 imageUrl: value3?["imageUrl"] as? String ?? "",
                                                                 postId: snapshot3.key))
                        
                        eTicketPake = kumpulanData.eTicket
                        
                        self.dispatchDelay(delay: 1.0) {
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                        //print("p")
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
            }
            else{
                self.refreshControl.endRefreshing()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        SATPoint.text = "Your SAT Point Is: \(point) from \(remainPoint)"
    }
    
    func dispatchDelay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eTicketPake.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = eTicketCellController.dequeueReusableCell(withReuseIdentifier: "ticketCell", for: indexPath) as! eTicketCollectionViewCell

        cell.eTicketImageLoader.startAnimating()

        let url = URL(string: eTicketPake[indexPath.row].imageUrl)
        ImageService.getImage(withURL: url!) { (image) in
            cell.eTicketImage.image = image

            cell.eTicketImageLoader.stopAnimating()
            cell.eTicketImageLoader.hidesWhenStopped = true
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        ref.keepSynced(true)
//
//        print("synced!")
        print("!")
        
        postId = eTicketPake[indexPath.row].postId
        performSegue(withIdentifier: "eTicketDetails", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "eTicketDetails"{
                let destination = segue.destination as! detail6ViewController
                print("2")
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
