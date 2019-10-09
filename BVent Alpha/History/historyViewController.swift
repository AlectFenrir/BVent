//
//  historyViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 05/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import EventKit
import LocalAuthentication

class historyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var historyTable: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var ongoing: [Enroll] = []
    var selectedIndex: Int!
    
    var filteredData: [Enroll] = []
    var postId: String = ""
    
    var deleteIndex: Int?
    var validation: Int?
    
    var ref: DatabaseReference!
    
    var name: String = ""
    
    let eventStore: EKEventStore = EKEventStore()
    var events: [EKEvent]?
    
    var val: Bool = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Fetching History Event Data", attributes: attributes)
        
        refreshControl.addTarget(self, action: #selector(historyViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = attributedTitle
        refreshControl.attributedTitle = NSAttributedString(string:"Last updated on " + NSDate().description)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.historyTable.estimatedRowHeight = 10
        self.historyTable.rowHeight = UITableViewAutomaticDimension
        
        historyPake.removeAll()
        kumpulanData.history.removeAll()
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        let userID = Auth.auth().currentUser?.uid
        
        self.eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                self.ref.child("users").child("regular").child(userID!).child("enroll").observe(.value) { (snapshot) in
                    // Get user value
                    let value = snapshot.value as? NSDictionary
                    
                    if (snapshot.exists()){
                        
                        for postId in (value?.allKeys(for: false))!{
                            
                            self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot2) in
                                // Get user value
                                let value2 = snapshot2.value as? NSDictionary
                                
                                kumpulanData.history.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
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
                                                                         postId: snapshot2.key,
                                                                         highlights: value2?["highlights"] as? Bool ?? true))
                                
                                historyPake = kumpulanData.history
                                
                                self.historyTable.reloadData()
                                //print("p")
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                            
                        }
                    }
                    else{
                        print("History Snapshot Exists!")
                    }
                    
                }
            }
            else{
                
                print("failed to save event with error : \(error) or access not granted")
            }
        }
        
        historyTable.refreshControl = refreshControl
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        historyPake.removeAll()
        kumpulanData.history.removeAll()
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child("regular").child(userID!).child("enroll").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys(for: false))!{
                    
                    self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot2) in
                        // Get user value
                        let value2 = snapshot2.value as? NSDictionary
                        
                        kumpulanData.history.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
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
                                                                 postId: snapshot2.key,
                                                                 highlights: value2?["highlights"] as? Bool ?? true))
                        
                        historyPake = kumpulanData.history
                        
                        self.dispatchDelay(delay: 1.0) {
                            self.historyTable.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                        //print("p")
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
                self.dispatchDelay(delay: 1.0) {
                    self.historyTable.reloadData()
                    self.refreshControl.endRefreshing()
                }
                
            }
            else{
                self.dispatchDelay(delay: 1.0) {
                    self.historyTable.reloadData()
                    self.refreshControl.endRefreshing()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func dispatchDelay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        fetchData()
    //    }
    //
    //    func fetchData()
    //    {
    //        do
    //        {
    //            ongoing = try context.fetch(Enroll.fetchRequest())
    //            filteredData = ongoing
    //            DispatchQueue.main.async {
    //                self.ongoingTable.reloadData()
    //            }
    //        }
    //        catch
    //        {
    //            print("Couldn't Fetch Data")
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyPake.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTable.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! historyTableViewCell
        
        // Configure the cell...
//        cell.historyImageLoader.startAnimating()
        
        let url = URL(string: historyPake[indexPath.row].imageUrl)
        cell.historyImage.load(url: url!)
        
//        ImageService.getImage(withURL: url!) { (image) in
//            cell.historyImage.image = image
//
//            cell.historyImageLoader.stopAnimating()
//            cell.historyImageLoader.hidesWhenStopped = true
//        }
        
        //cell.ongoingEventImage.image = filteredData[indexPath.row].ongoingImage as? UIImage
        cell.historyTitle.text = historyPake[indexPath.row].title
        cell.historyDate.text =  historyPake[indexPath.row].time
        cell.historyPlace.text = historyPake[indexPath.row].location
        
//        ref = Database.database().reference()
//        ref.child("users").child("regular").child(pake[indexPath.row].poster).child("profile").observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            self.name = value?["fullname"] as? String ?? ""
//            //cell.ongoingEventPoster.text = self.name
//
//            print("a")
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
//        if (historyPake[indexPath.row].done == true){ //REVISI
//            cell.done.text = "DONE"
//            cell.done.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
//        }
//        else{
//            cell.done.text = ""
//        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let context = LAContext()
        var error: NSError?
        context.localizedFallbackTitle = "Use Passcode"
        
        let delete = UITableViewRowAction(style: .destructive, title: "Un-Enroll") { (action, indexPath) in
            // delete item at indexPath
            //let event:EKEvent = EKEvent(eventStore: self.eventStore)
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference(fromURL: "https://bvent-alpha-1.firebaseio.com/")
            let groupRef = ref.child("users").child("regular").child(userID!).child("enroll").child(historyPake[indexPath.row].postId)
            let attendeesRef = ref.child("posts").child(historyPake[indexPath.row].postId).child("attendees").child(userID!)
            // ^^ this only works if the value is set to the firebase uid, otherwise you need to pull that data from somewhere else.
            
            let alert = UIAlertController(title: "Un-Enroll", message: "You can't undo this un-errollment", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Confirm", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button tapped.
                if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                    let reason = "Identify yourself!"
                    
                    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                        [unowned self] success, authenticationError in
                        
                        DispatchQueue.main.async {
                            if success {
                                print("Confirm button tapped");
                                groupRef.removeValue()
                                attendeesRef.removeValue()
                                historyPake.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .fade)
                                //self.deleteEntry(event: event)
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
                    self.present(ac, animated: true)
                }
                
            }
            alert.addAction(OKAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
                print("Cancel button tapped");
            }
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // delete item at indexPath
            
            let alert3 = UIAlertController(title: "This Feature Is Not Ready Yet!", message: nil, preferredStyle: .alert)
            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert3.addAction(action3)
            self.present(alert3, animated: true, completion: nil)
            
        }
        
        //delete.backgroundColor = #colorLiteral(red: 0.2293260694, green: 0.4044057131, blue: 0.57067734, alpha: 1)
        share.backgroundColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1.0)
        
        return [delete,share]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("users").child("regular").child(userID!).child("enroll").child(historyPake[indexPath.row].postId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.val = (snapshot.value as? Bool)!
            
            print(snapshot)
            
            if (self.val == false){
                self.failed()
            }
            else{
                self.postId = historyPake[indexPath.row].postId
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
        performSegue(withIdentifier: "ongoingDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "ongoingDetails"{
                let destination = segue.destination as! detail5ViewController
                destination.postId = postId
            }
        }
    }
    
    //    func deleteEntry(event : EKEvent){
    //        do{
    //            try eventStore.remove(event, span: EKSpan.thisEvent, commit: true)
    //        }catch{
    //            print("Error while deleting event: \(error.localizedDescription)")
    //        }
    //    }
}
