//
//  eTicketViewController.swift
//  BVent Alpha
//
//  Created by ken delatifani on 28/07/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication
import EventKit
import CoreData

class eTicketViewController: UIViewController {

    var ref: DatabaseReference!
    var userLempar: User!
    var ticketPake: kumpulanData!
    var ticketPake2: [kumpulanData] = []
    var ticketData: [kumpulanData] = kumpulanData.fetch()
    var index: Int?
    var validation: Bool = false
    var val = false
    var posterId: String = ""
    var postId: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var ticketName: UILabel!
    @IBOutlet weak var ticketUniversity: UILabel!
    @IBOutlet weak var ticketEvent: UILabel!
    @IBOutlet weak var ticketDate: UILabel!
    @IBOutlet weak var ticketLocation: UILabel!
    @IBOutlet weak var ticketDescription: UILabel!
    @IBAction func ticketConfirm(_ sender: Any) {
        confirm()
    }
    @IBAction func ticketMessage(_ sender: Any) {
        message()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTicket()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func fetchTicket() {
        val = false
        
        //ticketPake2 = ticketData
        
        ref = Database.database().reference()
        //storageRef = Storage.storage().reference()
        
        ref.keepSynced(true)
        
        ref.child("posts").child(postId!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value2 = snapshot.value as? NSDictionary
            //let username = value?["username"] as? String ?? ""
            self.ticketPake = kumpulanData.init(benefit: value2?["benefit"] as? String ?? "", bookmark: value2?["bookmark"] as? Bool ?? false, category: value2?["category"] as? String ?? "", certification: value2?["certification"] as? Bool ?? false, confirmCode: value2?["confirmCode"] as? String ?? "", cp: value2?["cp"] as? String ?? "", date: value2?["date"] as? String ?? "", desc: value2?["desc"] as? String ?? "", done: value2?["done"] as? Bool ?? false, enroll: value2?["enroll"] as? Bool ?? false, location: value2?["location"] as? String ?? "", price: value2?["price"] as? String ?? "", sat: value2?["sat"] as? Int ?? 0, time: value2?["time"] as? String ?? "", title: value2?["title"] as? String ?? "", timestamp: value2?["timestamp"] as? String ?? "", poster: value2?["poster"] as? String ?? "", imageUrl: value2?["imageUrl"] as? String ?? "", postId: self.postId!, highlights: value2?["highlights"] as? Bool ?? true)
            
            self.ticketEvent.text = self.ticketPake.title
            self.ticketDescription.text = self.ticketPake.desc
            self.ticketLocation.text = self.ticketPake.location
            self.ticketDate.text = self.ticketPake.date
            
            self.ticketEvent.sizeToFit()
            self.ticketDescription.sizeToFit()
            self.ticketLocation.sizeToFit()
            self.ticketDate.sizeToFit()
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        //self.loggedInUser = Auth.auth().currentUser
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child("regular").child(userID!).child("profile").queryLimited(toLast: 10).observe(.value, with: { (snapshot) in
            let snapshot = snapshot.value as! [String: AnyObject]
            self.ticketName.text = snapshot["fullname"] as? String
            self.ticketUniversity.text = snapshot["university"] as? String
        })
    }
    
    func message() {
        posterId = self.ticketPake.poster
        //posterId = ticketPake![index!].poster
        
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
                    
                    self.performSegue(withIdentifier: "ticketChatSegue", sender: nil)
                    
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
    
    func confirm() {
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        let context = LAContext()
        var error: NSError?
        context.localizedFallbackTitle = "Use Passcode"
        
        //        let customViewController: ongoingViewController = ongoingViewController(nibName: nil, bundle: nil)
        //        let ongoingTable2 = customViewController.ongoingTable
        
        
        if (self.validation == false) {
            //            let alert = UIAlertController(title: "Verification Code", message: nil, preferredStyle: .alert)
            //            alert.addTextField { (textField) in
            //                textField.placeholder = "Code"
            //            }
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                    [unowned self] success, authenticationError in
                    
                    DispatchQueue.main.async {
                        if success {
                            
                            let alert1 = UIAlertController(title: "Verified!", message: nil, preferredStyle: .alert)
                            
                            point = point + self.ticketPake.sat
                            print(point)
                            
                            self.ref.child("users").child("regular").child(userID!).child("profile").updateChildValues(["SAT": String(point)])
                            
                            let action1 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
                            
                            alert1.addAction(action1)
                            self.present(alert1, animated: true, completion: nil)
                            
                            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Enroll")
                            
                            let predicate = NSPredicate(format: "done = '\(false)'")
                            fetchRequest.predicate = predicate
                            do
                            {
                                let test = try self.context.fetch(fetchRequest)
                                if test.count == 1
                                {
                                    let objectUpdate = test[0] as! NSManagedObject
                                    objectUpdate.setValue(true, forKey: "done")
                                    do{
                                        try self.context.save()
                                    }
                                    catch
                                    {
                                        print(error)
                                    }
                                }
                            }
                            catch
                            {
                                print(error)
                            }
                            
                            self.ticketPake.enroll = true
                            self.validation = true
                            
                            self.ref.child("users").child("regular").child(userID!).child("enroll").child(self.postId!).setValue(false)
                            
                            _ = self.navigationController?.popViewController(animated: true)
                            
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
            
        } else {
            //print("BEGO")
            
            let alert3 = UIAlertController(title: "You've verified already!", message: nil, preferredStyle: .alert)
            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert3.addAction(action3)
            self.present(alert3, animated: true, completion: nil)
            
        }
        
    }
    
}
