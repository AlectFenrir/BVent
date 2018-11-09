//
//  User.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 07/11/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class User: NSObject {
    
    //MARK: Properties
    let fullname: String
    let email: String
    let phoneNumber: String
    let id: String
    var SAT: String
    var profilePic: UIImage
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, phoneNumber: String, password: String, profilePic: UIImage, SAT: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                //user?.sendEmailVerification(completion: nil)
                let storageRef = Storage.storage().reference().child("users").child("regular").child(user!.uid).child("profileImage")
                let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
                storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
                    if err == nil {
                        let path = metadata?.downloadURL()?.absoluteString
                        let values = ["fullname": withName, "email": email, "phoneNumber": phoneNumber, "photoURL": path!, "SAT": SAT]
                        Database.database().reference().child("users").child("regular").child((user?.uid)!).child("profile").updateChildValues(values, withCompletionBlock: { (errr, _) in
                            if errr == nil {
                                let userInfo = ["email" : email, "password" : password]
                                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                                completion(true)
                            }
                        })
                    }
                })
            }
            else {
                completion(false)
            }
        })
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        let userId = Auth.auth().currentUser?.uid
        
        ref.child("users").child("regular").child(userId!).child("profile").observeSingleEvent(of: .value, with: {(snapshot) in
            let snapshot = snapshot.value as! [String: AnyObject]
            
            point = snapshot["SAT"] as! Int
            
            
        })
        
        
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    class func info(forUserID: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child("regular").child(forUserID).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: String] {
                let fullname = data["fullname"]!
                let email = data["email"]!
                let phoneNumber = data["phoneNumber"]!
                let SAT = data["SAT"]!
                let link = URL.init(string: data["photoURL"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(fullname: fullname, email: email, phoneNumber: phoneNumber, id: forUserID, profilePic: profilePic!, SAT: SAT )
                        completion(user)
                    }
                }).resume()
            }
        })
    }
    
    class func downloadAllUsers(posterId: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child("regular").child(posterId).observeSingleEvent(of: .value, with: { (snapshot) in
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["profile"] as! [String: String]
            
                let fullname = credentials["fullname"]!
                let email = credentials["email"]!
                let phoneNumber = credentials["phoneNumber"]!
                let SAT = credentials["SAT"]
                let link = URL.init(string: credentials["photoURL"]!)
                URLSession.shared.dataTask(with: link!, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(fullname: fullname, email: email, phoneNumber: phoneNumber, id: id, profilePic: profilePic!, SAT: SAT!)
                        completion(user)
                    }
                }).resume()
            
        })
    }
    
    class func checkUserVerification(completion: @escaping (Bool) -> Swift.Void) {
        Auth.auth().currentUser?.reload(completion: { (_) in
            let status = (Auth.auth().currentUser?.isEmailVerified)!
            completion(status)
        })
    }
    
    
    //MARK: Inits
    init(fullname: String, email: String, phoneNumber: String, id: String, profilePic: UIImage, SAT: String) {
        self.fullname = fullname
        self.email = email
        self.phoneNumber = phoneNumber
        self.id = id
        self.profilePic = profilePic
        self.SAT = SAT
    }
}
