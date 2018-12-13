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
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountUniversity: UILabel!
    @IBOutlet weak var accountProfilePicture: UIImageView!
    @IBOutlet weak var accountHeaderPicture: UIImageView!
    @IBOutlet weak var myProfileImageLoader: UIActivityIndicatorView!
    //@IBOutlet weak var alertBottomConstraint: NSLayoutConstraint!
    var selectedUser: User?
    
    lazy var leftButton: UIBarButtonItem = {
        //let image = UIImage.init(named: "default profile")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(title: "Close", style: .plain, target: self, action: #selector(myProfileViewController.showHome))
        return button
    }()
    
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
    
    func customization()  {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        // notification setup
//        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.showEmailAlert), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        //right bar button
        let icon = UIImage.init(named: "message")?.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(myProfileViewController.showConversations))
        self.navigationItem.rightBarButtonItem = rightButton
        //left bar button image fetching
        self.navigationItem.leftBarButtonItem = self.leftButton
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
//        if let id = Auth.auth().currentUser?.uid {
//            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
//                let image = user.profilePic
//                let contentSize = CGSize.init(width: 30, height: 30)
//                UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
//                let _  = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14).addClip()
//                image.draw(in: CGRect(origin: CGPoint.zero, size: contentSize))
//                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14)
//                path.lineWidth = 2
//                UIColor.white.setStroke()
//                path.stroke()
//                let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
//                UIGraphicsEndImageContext()
//                DispatchQueue.main.async {
//                    weakSelf?.leftButton.image = finalImage
//                    weakSelf = nil
//                }
//            })
//        }
    }
    
//    @objc func showEmailAlert() {
//        User.checkUserVerification {[weak weakSelf = self] (status) in
//            status == true ? (weakSelf?.alertBottomConstraint.constant = -40) : (weakSelf?.alertBottomConstraint.constant = 0)
//            UIView.animate(withDuration: 0.3) {
//                weakSelf?.view.layoutIfNeeded()
//                weakSelf = nil
//            }
//        }
//    }
//
//    @objc func pushToUserMesssages(notification: NSNotification) {
//        if let user = notification.userInfo?["user"] as? User {
//            self.selectedUser = user
//            self.performSegue(withIdentifier: "segue", sender: self)
//        }
//    }
    
    @objc func showConversations() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Conversations") as! UIViewController
        self.show(vc, sender: nil)
        //self.present(vc, animated: true, completion: nil)
    }
    
    @objc func showHome() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromBottom
        //view.backgroundColor = UIColor.clear
        //view.window?.backgroundColor = UIColor.clear
        //view.window?.isOpaque = true
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: true, completion: nil)
    }
    
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
        //let backgroundView = UIView()
        //backgroundView.backgroundColor = UIColor.white
        //customization()
        
        val = false
        kumpulanData.eTicket.removeAll()
        eTicketPake.removeAll()
        
        ref = Database.database().reference()
        //storageRef = Storage.storage().reference()
        
        ref.keepSynced(true)
        
        //self.loggedInUser = Auth.auth().currentUser
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child("regular").child(userID!).child("profile").queryLimited(toLast: 10).observe(.value, with: { (snapshot) in
            let snapshot = snapshot.value as! [String: AnyObject]
            self.accountName.text = snapshot["fullname"] as? String
            self.accountUniversity.text = snapshot["university"] as? String
            //self.accountPhoneNumber.text = snapshot["phoneNumber"] as? String
            //self.accountEmail.text = snapshot["email"] as? String
            
            let satPoint = snapshot["SAT"]!
            //self.SATPoint.text = "Your SAT Point Is: \(satPoint) from \(remainPoint)"
            
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
        
//        btn.layer.cornerRadius = 7
//        btn.clipsToBounds = true
//        btn.layer.borderWidth = 0.25
//        btn.layer.borderColor = UIColor.black.cgColor
        
        self.eTicketCellController.reloadData()
        
        //self.view.addSubview(tableView)
        //self.view.addSubview(backgroundView)
        
        //himaBinus.image = UIImage(named: "calendar")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.tabBarController?.tabBar.isHidden = true
        
        self.eTicketCellController.reloadData()
        
        //kumpulanData.eTicket.removeAll()
        //eTicketPake.removeAll()
    }
    
    //var users: [NSManagedObject] = []
    
    
    internal func setProfilePicture(_ imageView:UIImageView,imageToSet:UIImage)
    {
        imageView.layer.cornerRadius = self.accountProfilePicture.frame.size.width / 2
        imageView.layer.borderColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
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

        btn.layer.cornerRadius = 7
        btn.clipsToBounds = true
        btn.layer.borderWidth = 0.25
        btn.layer.borderColor = UIColor.black.cgColor
        
        
        //SATPoint.text = "Your SAT Point Is: \(point) from \(remainPoint)"
    }
    
    func dispatchDelay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ongoingPake.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = eTicketCellController.dequeueReusableCell(withReuseIdentifier: "ticketCell", for: indexPath) as! eTicketCollectionViewCell

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
//        ref.keepSynced(true)
//
//        print("synced!")
        print("!")
        
        postId = ongoingPake[indexPath.row].postId
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("users").child("regular").child(userID!).child("enroll").child(ongoingPake[indexPath.row].postId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.val = (snapshot.value as? Bool)!
            
            print(snapshot)
            
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "eTicketDetails"{
                let destination = segue.destination as! detail6ViewController
                print("2")
                destination.postId = postId
            }
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
    
    @IBAction func message(_ sender: Any) {
        self.performSegue(withIdentifier: "My Conversations", sender: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        self.showHome()
    }
    
}
