//
//  LandingViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 07/11/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class LandingViewController: UIViewController {
    
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var loggedInUser: AnyObject?
    var loggedInUserData: NSDictionary?
    var storageRef: StorageReference?

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //MARK: Push to relevant ViewController
    func pushTo(viewController: ViewControllerType)  {
        switch viewController {
        case .home:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
            self.present(vc, animated: false, completion: nil)
        case .welcome:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "welcomeViewController") as! welcomeViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //MARK: Check if user is signed in or not
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let email = userInformation["email"] as! String
            let password = userInformation["password"] as! String
            User.loginUser(withEmail: email, password: password, completion: { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    if status == true {
                        weakSelf?.pushTo(viewController: .home)
                    } else {
                        weakSelf?.pushTo(viewController: .welcome)
                    }
                    weakSelf = nil
                }
            })
        } else {
            self.pushTo(viewController: .welcome)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pake.removeAll()
        kumpulanData.datas.removeAll()
        
        highlightsPake.removeAll()
        kumpulanData.highlights.removeAll()
        
        nearbyPake.removeAll()
        kumpulanData.nearby.removeAll()
        
        upcomingPake.removeAll()
        kumpulanData.upcoming.removeAll()
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        //let postsImageRef = storageRef?.child("posts")
        //self.postsRef.keepSynced(true)
        
        //        self.loggedInUser = Auth.auth().currentUser
        //
        //        self.ref?.child("users").child("regular").child(self.loggedInUser!.uid).child("profile").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
        //
        //            self.loggedInUserData = snapshot.value as? NSDictionary
        
        self.databaseHandle = self.ref.child("posts").queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? [String:Any]
            
            let temp = ambilData(fetch: value!)
            
            kumpulanData.datas.insert(kumpulanData(benefit: temp.benefit, bookmark: temp.bookmark, category: temp.category, certification: temp.certification, confirmCode: temp.confirmCode, cp: temp.cp, date: temp.date, desc: temp.desc, done: temp.done, enroll: temp.enroll, location: temp.location, price: temp.price, sat: temp.sat, time: temp.time, title: temp.title, timestamp: temp.timestamp, poster: temp.poster, imageUrl: temp.imageUrl, postId: snapshot.key, highlights: temp.highlights), at: 0)
            
            self.loggedInUser = Auth.auth().currentUser
            
            if temp.poster == self.loggedInUser?.uid{
                self.ref.child("users").child("regular").child(self.loggedInUser!.uid).child("posts").child(snapshot.key).setValue(true)
                
            }
            
            pake = kumpulanData.datas
            //pake.sort(by: {$0.date > $1.date})

        }
        
        self.databaseHandle = self.ref.child("posts").queryLimited(toLast: 5).observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? [String:Any]
            
            let temp = ambilData(fetch: value!)
            
            kumpulanData.highlights.insert(kumpulanData(benefit: temp.benefit, bookmark: temp.bookmark, category: temp.category, certification: temp.certification, confirmCode: temp.confirmCode, cp: temp.cp, date: temp.date, desc: temp.desc, done: temp.done, enroll: temp.enroll, location: temp.location, price: temp.price, sat: temp.sat, time: temp.time, title: temp.title, timestamp: temp.timestamp, poster: temp.poster, imageUrl: temp.imageUrl, postId: snapshot.key, highlights: temp.highlights), at: 0)
            
            self.loggedInUser = Auth.auth().currentUser
            
            if temp.poster == self.loggedInUser?.uid{
                self.ref.child("users").child("regular").child(self.loggedInUser!.uid).child("posts").child(snapshot.key).setValue(true)
                
            }
            
            highlightsPake = kumpulanData.highlights
            //pake.sort(by: {$0.date > $1.date})
        }
        
        self.databaseHandle = self.ref.child("posts").queryLimited(toLast: 9).observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? [String:Any]
            
            let temp = ambilData(fetch: value!)
            
            kumpulanData.nearby.insert(kumpulanData(benefit: temp.benefit, bookmark: temp.bookmark, category: temp.category, certification: temp.certification, confirmCode: temp.confirmCode, cp: temp.cp, date: temp.date, desc: temp.desc, done: temp.done, enroll: temp.enroll, location: temp.location, price: temp.price, sat: temp.sat, time: temp.time, title: temp.title, timestamp: temp.timestamp, poster: temp.poster, imageUrl: temp.imageUrl, postId: snapshot.key, highlights: temp.highlights), at: 0)
            
            self.loggedInUser = Auth.auth().currentUser
            
            if temp.poster == self.loggedInUser?.uid{
                self.ref.child("users").child("regular").child(self.loggedInUser!.uid).child("posts").child(snapshot.key).setValue(true)
                
            }
            
            nearbyPake = kumpulanData.nearby
            //pake.sort(by: {$0.date > $1.date})
        }
        
        self.databaseHandle = self.ref.child("posts").queryLimited(toLast: 20).observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? [String:Any]
            
            let temp = ambilData(fetch: value!)
            
            kumpulanData.upcoming.insert(kumpulanData(benefit: temp.benefit, bookmark: temp.bookmark, category: temp.category, certification: temp.certification, confirmCode: temp.confirmCode, cp: temp.cp, date: temp.date, desc: temp.desc, done: temp.done, enroll: temp.enroll, location: temp.location, price: temp.price, sat: temp.sat, time: temp.time, title: temp.title, timestamp: temp.timestamp, poster: temp.poster, imageUrl: temp.imageUrl, postId: snapshot.key, highlights: temp.highlights), at: 0)
            
            self.loggedInUser = Auth.auth().currentUser
            
            if temp.poster == self.loggedInUser?.uid{
                self.ref.child("users").child("regular").child(self.loggedInUser!.uid).child("posts").child(snapshot.key).setValue(true)
                
            }
            
            upcomingPake = kumpulanData.upcoming
            //pake.sort(by: {$0.date > $1.date})
        }
    }

}
