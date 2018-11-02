//
//  attendeesViewController.swift
//  BVent Alpha
//
//  Created by jonathan jordy on 31/10/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class attendeesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var postId: String?
    
    var ref : DatabaseReference!
    
    struct attendee{
    
        var fullName: String
        var email: String
        
        static var profile : [attendee] = []
    
    }
    
    var attendeesName: [String] = []
    var attendeesEmail: [String] = []

    @IBOutlet weak var table: UITableView!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Fetching Attendees Data", attributes: attributes)

        refreshControl.addTarget(self, action: #selector(attendeesViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = attributedTitle

        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print ("a")
        
        //attendee.profile.removeAll()
        
        attendeesEmail.removeAll()
        attendeesName.removeAll()
        
        self.ref = Database.database().reference()
        self.ref.keepSynced(true)
        
        ref.child("posts").child(postId!).child("attendees").queryLimited(toLast: 250).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for userId in (value?.allKeys)!{
                    
                    self.ref.child("users").child("regular").child(userId as! String).child("profile").queryLimited(toLast: 250).observeSingleEvent(of: .value, with: { (snapshot2) in
                        // Get user value
                        let value2 = snapshot2.value as? NSDictionary
                        //let username = value?["username"] as? String ?? ""
                        
                        //                          attendee.profile.append(attendee(
                        //
                        //                              fullName: value2?["fullname"] as? String ?? "",
                        //                              email: value2?["email"] as? String ?? ""))
                        self.attendeesName.append(value2?["fullname"] as? String ?? "")
                        self.attendeesEmail.append(value2?["email"] as? String ?? "")
                        
                        self.table.reloadData()
                        
                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.table.addSubview(self.refreshControl)
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {

        print ("a")

        //attendee.profile.removeAll()

        attendeesEmail.removeAll()
        attendeesName.removeAll()

        self.ref = Database.database().reference()
        self.ref.keepSynced(true)

        ref.child("posts").child(postId!).child("attendees").queryLimited(toLast: 250).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary

            if (snapshot.exists()){

                for userId in (value?.allKeys)!{

                    self.ref.child("users").child("regular").child(userId as! String).child("profile").queryLimited(toLast: 250).observeSingleEvent(of: .value, with: { (snapshot2) in
                        // Get user value
                        let value2 = snapshot2.value as? NSDictionary
                        //let username = value?["username"] as? String ?? ""

                        //                          attendee.profile.append(attendee(
                        //
                        //                              fullName: value2?["fullname"] as? String ?? "",
                        //                              email: value2?["email"] as? String ?? ""))
                        self.attendeesName.append(value2?["fullname"] as? String ?? "")
                        self.attendeesEmail.append(value2?["email"] as? String ?? "")

                        self.table.reloadData()

                        self.dispatchDelay(delay: 2.0) {
                            self.refreshControl.endRefreshing()
                        }

                        // ...
                    }) { (error) in
                        print(error.localizedDescription)
                    }

                }

            }

        }) { (error) in
            print(error.localizedDescription)
        }

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return attendeesName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "attendees", for: indexPath) as! attendeesTableViewCell
        
        cell.attendeesName.text = attendeesName[indexPath.row]
        cell.attendeesEmail.text = attendeesEmail[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func dispatchDelay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
