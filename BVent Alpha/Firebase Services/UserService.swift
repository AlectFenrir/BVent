//
//  UserService.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 25/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import Foundation
import Firebase

class UserService
{
    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping ((_ userProfile:UserProfile?)->())) {
        let userRef = Database.database().reference().child("users/regular/\(uid)/profile")
        
        userRef.observe(.value, with: { snapshot in
            var userProfile:UserProfile?
            
            if let dict = snapshot.value as? [String:Any],
                let fullname = dict["fullname"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let userEmail = dict["userEmail"] as? String,
                let phoneNumber = dict["phoneNumber"] as? String,
                let url = URL(string:photoURL) {
                
                userProfile = UserProfile(uid: snapshot.key, fullname: fullname, photoURL: url, userEmail: userEmail, phoneNumber: phoneNumber)
            }
            
            completion(userProfile)
        })
    }
}
