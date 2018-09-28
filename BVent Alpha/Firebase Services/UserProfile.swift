//
//  UserProfile.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 25/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import Foundation
import Firebase

class UserProfile {
    var uid:String
    var fullname:String
    var photoURL:URL
    //var photoURL:String
    var userEmail:String
    var phoneNumber:String
    //var key:String
    //var ref: DatabaseReference!
    
//    init?(snapshot: DataSnapshot?) {
//
//        guard let value = snapshot?.value as? [String: AnyObject],
//            let fullname = value["fullname"] as? String,
//            let email = value["email"] as? String,
//            let uid = value["uid"] as? String,
//            let photoURL = value["photoURL"] as? String,
//            let phoneNumber = value["phoneNumber"] as? String else {
//                return nil
//        }
//
//        self.key = (snapshot?.key)!
//        self.ref = snapshot?.ref
//        self.fullname = fullname
//        self.userEmail = email
//        self.uid = uid
//        self.photoURL = photoURL
//        self.phoneNumber = phoneNumber
//    }
    
    
    init(uid:String,fullname:String,photoURL:URL, userEmail:String, phoneNumber:String) {
        self.uid = uid
        self.fullname = fullname
        self.photoURL = photoURL
        self.userEmail = userEmail
        self.phoneNumber = phoneNumber
    }
    
//    init(dictionary: [String: AnyObject]) {
//        self.fullname = (dictionary["fullname"] as? String)!
//        self.photoURL = (dictionary["photoURL"] as? String)!
//        self.userEmail = (dictionary["userEmail"] as? String)!
//        self.phoneNumber = (dictionary["phoneNumber"] as? String)!
//    }
}
