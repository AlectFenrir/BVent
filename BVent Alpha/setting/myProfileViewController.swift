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

class myProfileViewController: UIViewController {
    
    @IBOutlet weak var himaBinus: UIImageView!
    @IBOutlet weak var himaBinusButton: UIButton!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var SATPoint: UILabel!
    @IBOutlet weak var accountEmail: UILabel!
    @IBOutlet weak var accountPhoneNumber: UILabel!
    @IBOutlet weak var accountProfilePicture: UIImageView!
    
    var loggedInUser: AnyObject?
    //var databaseRef = Database.database().reference()
    //var storageRef = Storage.storage().reference()
    var databaseRef: DatabaseReference!
    var storageRef: StorageReference!
    
    @IBOutlet weak var btn: UIButton!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user = [UserProfile]()
    
    //var fullnameArray = [String]()
    
    //var filteredData: [SignUp] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        storageRef = Storage.storage().reference()
        
        self.loggedInUser = Auth.auth().currentUser
        
        self.databaseRef.child("users").child("regular").child(self.loggedInUser!.uid).child("profile").observe(.value, with: { (snapshot) in
            let snapshot = snapshot.value as! [String: AnyObject]
            self.accountName.text = snapshot["fullname"] as? String
            //self.accountPhoneNumber.text = snapshot["phoneNumber"] as? String
            //self.accountEmail.text = snapshot["email"] as? String
            
            let databaseProfilePic = snapshot["photoURL"]
                as! String
            
            let data = try? Data(contentsOf: URL(string: databaseProfilePic)!)
            
            self.setProfilePicture(self.accountProfilePicture,imageToSet:UIImage(data:data!)!)
        })
        
        btn.layer.cornerRadius = 7
        btn.clipsToBounds = true
        btn.layer.borderWidth = 0.25
        btn.layer.borderColor = UIColor.black.cgColor
        
        //fetchData()
        
        //fetchUserProfile()
        
        //fetchUserData()
        
        //fetchUserDataCustom()
        
        //fetchUserInfoTesting()
        
        //fetchCurrentUserInfo()
        
        //set(user: <#T##UserProfile#>)
        
        //        accountName.text = user[0].fullname
        //
        //        accountPhoneNumber.text = user[0].phoneNumber
        //
        //        accountEmail.text = user[0].userEmail
        
        
        
        SATPoint.text = "Your SAT Point Is: \(point) from \(remainPoint)"
        
        //himaBinus.image = UIImage(named: "calendar")
        
        
        // Do any additional setup after loading the view.
    }
    
    //var users: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //fetchData()
    }
    
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
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
