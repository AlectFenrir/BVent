//
//  detail1ViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 26/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication
import EventKit

class detail1ViewController: UIViewController {
    
    @IBOutlet weak var foto: WebImageView! {
        didSet {
            foto.configuration.placeholderImage = UIImage(named: "lightGray")
            foto.configuration.animationOptions = .transitionCrossDissolve
        }
    }
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventPoster: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var isi: UILabel!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var tempat: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var jam: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var enrollBtn: UIButton!
    @IBOutlet weak var detail1ImageLoader: UIActivityIndicatorView!
    
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
    
    var data: [kumpulanData] = kumpulanData.fetch()
    
    var pake: [kumpulanData] = []
    
    var index: Int?
    
    var phoneNumber: String = ""
    
    var ref: DatabaseReference!
    
    var val = false
    
    var posterId: String = ""
    
    var name: String = ""
    
    var userLempar: User!
    
    let eventStore: EKEventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        val = false
        
        pake = data
        
        self.title = pake[index!].title
        eventTitle.text = pake[index!].title
        
        ref = Database.database().reference()
        ref.child("users").child("regular").child(pake[index!].poster).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.name = value?["fullname"] as? String ?? ""
            self.eventPoster.text = "by \(self.name)"
            
            print("a")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //foto.image = pake[index!].image
        
        //detail1ImageLoader.startAnimating()
        
        let url = URL(string: pake[index!].imageUrl)
        self.foto.load(url: url!)
        
//        ImageService.getImage(withURL: url!) { (image) in
//            self.foto.image = image
//
//            self.detail1ImageLoader.stopAnimating()
//            self.detail1ImageLoader.hidesWhenStopped = true
//        }
        
        //time.text = pake[index!].cdown
        
        if (pake[index!].price == ""){
            price.text = "Free"
        }
        else{
            price.text = "Rp. \(pake[index!].price)"
        }
        
        //category.text = "in \(pake[index!].category)"
        isi.text = pake[index!].desc
        tempat.text = "Place: \(pake[index!].location)"
        waktu.text = "Date: \(pake[index!].date)"
        jam.text = "Time: \(pake[index!].time)"
        
        if (pake[index!].benefit != ""){
            
            if (pake[index!].certification == true){
                benefit.text = "Benefits: \(pake[index!].benefit), Certificate"
            }
            else{
                benefit.text = "Benefit: \(pake[index!].benefit)"
            }
            
        }
        else{
            
            if (pake[index!].certification == true){
                benefit.text = "Benefit: Certificate"
            }
            else{
                benefit.text = ""
            }
        }
        
        isi.sizeToFit()
        
        phoneNumber = pake[index!].cp
        
//        saveBtn.layer.cornerRadius = 7
//        saveBtn.clipsToBounds = true
//        saveBtn.layer.borderWidth = 0.25
//        saveBtn.layer.borderColor = UIColor.black.cgColor
//        
//        enrollBtn.layer.cornerRadius = 7
//        enrollBtn.clipsToBounds = true
//        enrollBtn.layer.borderWidth = 0.25
//        enrollBtn.layer.borderColor = UIColor.black.cgColor
//
//        decsBtn.layer.cornerRadius = 7
//        decsBtn.clipsToBounds = true
//        decsBtn.layer.borderWidth = 0.25
//        decsBtn.layer.borderColor = UIColor.white.cgColor
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func enroll(_ sender: UIButton) {
        
        self.ref = Database.database().reference()
        let userID = Auth.auth().currentUser
        
        let context = LAContext()
        var error: NSError?
        context.localizedFallbackTitle = "Use Passcode"
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                [unowned self] success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.ref.child("users").child("regular").child(userID!.uid).child("enroll").observeSingleEvent(of: .value, with: { (snapshot) in
                            // Get user value
                            let value = snapshot.value as? NSDictionary
                            
                            if (snapshot.exists()){
                                
                                for postId in (value?.allKeys)!{
                                    
                                    if (self.pake[self.index!].postId == postId as! String){
                                        self.val = true
                                    }
                                    
                                }
                                
                                if (self.val == true){
                                    
                                    let alert = UIAlertController(title: "You've been enrolled!", message: nil, preferredStyle: .alert)
                                    
                                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                                    
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }
                                else{
                                    self.ref.child("users").child("regular").child(userID!.uid).child("enroll").child(self.pake[self.index!].postId).setValue(true)
                                    self.ref?.child("posts").child(self.pake[self.index!].postId).child("attendees").child(userID!.uid).setValue(true)
                                    
                                    let alert = UIAlertController(title: "Enrolled!", message: nil, preferredStyle: .alert)
                                    
                                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                                    
                                    alert.addAction(action)
                                    self.present(alert, animated: true, completion: nil)
                                    
                                    self.eventStore.requestAccess(to: .event) { (granted, error) in
                                        
                                        if (granted) && (error == nil) {
                                            print("granted \(granted)")
                                            print("error \(error)")
                                            
                                            let event:EKEvent = EKEvent(eventStore: self.eventStore)
                                            let alarm30minutes = EKAlarm(relativeOffset: -1800)
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.locale = Locale(identifier: "en_ID")
                                            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                                            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00") //Current time zone
                                            //according to date format your date string
                                            let date = dateFormatter.date(from: self.pake[self.index!].date)
                                            print(date)
                                            
                                            var predicateString = "title == '\(event.title)' AND location == '\(event.location)' AND notes == '\(event.notes)'"
                                            var matches = NSPredicate(format: predicateString)
                                            var datedEvents: [EKEvent]? = nil
                                            if let aDate = event.endDate {
                                                datedEvents = self.eventStore.events(matching: self.eventStore.predicateForEvents(withStart: event.startDate, end: aDate, calendars: nil))
                                            }
                                            var matchingEvents = (datedEvents as NSArray?)?.filtered(using: matches)
                                            
                                            event.title = self.pake[self.index!].title
                                            event.startDate = date
                                            event.endDate = date!.addingTimeInterval(7200 as TimeInterval)
                                            event.notes = self.pake[self.index!].desc
                                            event.location = self.pake[self.index!].location
                                            event.addAlarm(alarm30minutes)
                                            event.calendar = self.eventStore.defaultCalendarForNewEvents
                                            do {
                                                try self.eventStore.save(event, span: .thisEvent)
                                            } catch let error as NSError {
                                                print("failed to save event with error : \(error)")
                                            }
                                            print("Saved Event")
                                        }
                                        else{
                                            
                                            print("failed to save event with error : \(error) or access not granted")
                                        }
                                    }
                                }
                                
                            }
                            else{
                                self.ref.child("users").child("regular").child(userID!.uid).child("enroll").child(self.pake[self.index!].postId).setValue(true)
                                self.ref?.child("posts").child(self.pake[self.index!].postId).child("attendees").child(userID!.uid).setValue(true)
                                
                                let alert = UIAlertController(title: "Enrolled!", message: nil, preferredStyle: .alert)
                                
                                let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                                
                                alert.addAction(action)
                                self.present(alert, animated: true, completion: nil)
                                
                                self.eventStore.requestAccess(to: .event) { (granted, error) in
                                    
                                    if (granted) && (error == nil) {
                                        print("granted \(granted)")
                                        print("error \(error)")
                                        
                                        let event:EKEvent = EKEvent(eventStore: self.eventStore)
                                        let alarm30minutes = EKAlarm(relativeOffset: -1800)
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.locale = Locale(identifier: "en_ID")
                                        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                                        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+7:00") //Current time zone
                                        //according to date format your date string
                                        let date = dateFormatter.date(from: self.pake[self.index!].date)
                                        print(date)
                                        
                                        var predicateString = "title == '\(event.title)' AND location == '\(event.location)' AND notes == '\(event.notes)'"
                                        var matches = NSPredicate(format: predicateString)
                                        var datedEvents: [EKEvent]? = nil
                                        if let aDate = event.endDate {
                                            datedEvents = self.eventStore.events(matching: self.eventStore.predicateForEvents(withStart: event.startDate, end: aDate, calendars: nil))
                                        }
                                        var matchingEvents = (datedEvents as NSArray?)?.filtered(using: matches)
                                        
                                        event.title = self.pake[self.index!].title
                                        event.startDate = date
                                        event.endDate = date!.addingTimeInterval(7200 as TimeInterval)
                                        event.notes = self.pake[self.index!].desc
                                        event.location = self.pake[self.index!].location
                                        event.addAlarm(alarm30minutes)
                                        event.calendar = self.eventStore.defaultCalendarForNewEvents
                                        do {
                                            try self.eventStore.save(event, span: .thisEvent)
                                        } catch let error as NSError {
                                            print("failed to save event with error : \(error)")
                                        }
                                        print("Saved Event")
                                    }
                                    else{
                                        
                                        print("failed to save event with error : \(error) or access not granted")
                                    }
                                }
                            }
                            
                            //let username = value?["username"] as? String ?? ""
                            
                            // ...
                        }) { (error) in
                            print(error.localizedDescription)
                        }
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
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        self.ref = Database.database().reference()
        let userID = Auth.auth().currentUser
        
        ref.child("users").child("regular").child(userID!.uid).child("bookmark").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys)!{
                    
                    if (self.pake[self.index!].postId == postId as! String){
                        self.val = true
                    }
                    
                }
                
                if (self.val == true){
                    
                    let alert = UIAlertController(title: "The Post Is Saved Already!", message: nil, preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else{
                    self.ref.child("users").child("regular").child(userID!.uid).child("bookmark").child(self.pake[self.index!].postId).setValue(true)
                    
                    let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else{
                self.ref.child("users").child("regular").child(userID!.uid).child("bookmark").child(self.pake[self.index!].postId).setValue(true)
                
                let alert = UIAlertController(title: "Saved!", message: nil, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
            //let username = value?["username"] as? String ?? ""
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func previewActionItems() -> [UIPreviewActionItem] {
        
        let Share = UIPreviewAction(title: "Share", style: .default) { (action, viewController) -> Void in
            
            let alert3 = UIAlertController(title: "This Feature Is Not Ready Yet!", message: nil, preferredStyle: .alert)
            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert3.addAction(action3)
            self.present(alert3, animated: true, completion: nil)
        }
        
        return [Share]
        
    }
    
    @IBAction func message(_ sender: Any) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Navigation") as! UINavigationController
//        self.show(vc, sender: nil)
        
        posterId = pake[index!].poster
        
        self.ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        
        self.ref.child("users").child("regular").child(posterId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let id = snapshot.key
            let data = snapshot.value as! [String: Any]
            let credentials = data["profile"] as! [String: String]
            
            let fullname = credentials["fullname"]!
            let email = credentials["email"]!
            let studentID = credentials["studentID"]!
            let major = credentials["major"]!
            let university = credentials["university"]!
            let phoneNumber = credentials["phoneNumber"]!
            let SAT = credentials["SAT"]
            let link = URL.init(string: credentials["photoURL"]!)
            
            ImageService.getImage(withURL: link!) {(image) in
                
                let profilePic = image
                let user = User.init(fullname: fullname, email: email, phoneNumber: phoneNumber, id: id, studentID: studentID, major: major, university: university, profilePic: profilePic!, SAT: SAT!)
                self.userLempar = user
                
                if (userID != self.posterId) {
                    
                    self.performSegue(withIdentifier: "chat segue", sender: nil)
                    
                } else {
                    let alert = UIAlertController(title: "You Can't Chat Yourself!", message: nil, preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (_) in}
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    @IBAction func close(_ sender: Any) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "chat segue"{
                
                let destination = segue.destination as! ChatViewController
                destination.currentUser = self.userLempar
                
            }
        }
    }
    
}
