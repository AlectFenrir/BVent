//
//  myPostViewController.swift
//  BVent Alpha
//
//  Created by jonathan jordy on 30/10/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class myPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var table: UITableView!
    
    var test = ["Hello", "Hi"]
    
    var ref : DatabaseReference!
    
    var postId: String = ""
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Fetching My Post(s) Data", attributes: attributes)
        
        refreshControl.addTarget(self, action: #selector(myPostViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = attributedTitle
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kumpulanData.myPosts.removeAll()
        
        self.ref = Database.database().reference()
        self.ref.keepSynced(true)
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child("regular").child(userID!).child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
            
            for postId in (value?.allKeys)!{
                
                self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot2) in
                    // Get user value
                    let value2 = snapshot2.value as? NSDictionary
                
                    kumpulanData.myPosts.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
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
                                                             postId: snapshot2.key))
                    
                    myPostPake = kumpulanData.myPosts
                    
                    self.table.reloadData()
                    //print("p")
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            }
            }
            else{
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.table.addSubview(self.refreshControl)

        // Do any additional setup after loading the view.
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        kumpulanData.myPosts.removeAll()
        
        self.ref = Database.database().reference()
        self.ref.keepSynced(true)
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child("regular").child(userID!).child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys)!{
                    
                    self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot2) in
                        // Get user value
                        let value2 = snapshot2.value as? NSDictionary
                        
                        kumpulanData.myPosts.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
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
                                                                 postId: snapshot2.key))
                        
                        myPostPake = kumpulanData.myPosts
                        
                        self.table.reloadData()
                        
                        self.dispatchDelay(delay: 2.0) {
                            self.refreshControl.endRefreshing()
                        }
                        //print("p")
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
            }
            else{
                
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPostPake.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "myPost", for: indexPath) as! myPostTableViewCell
        
        if (myPostPake[indexPath.row].imageUrl != ""){
        
        cell.myPostImageLoader.startAnimating()
        
        let url = URL(string: myPostPake[indexPath.row].imageUrl)
        
//        let dataImage = try? Data(contentsOf: url!)
//
//        if let imageData = dataImage {
//            cell.myPostPhoto.image = UIImage(data: imageData)
//            }
            ImageService.getImage(withURL: url!) { (image) in
                cell.myPostPhoto.image = image
                
                cell.myPostImageLoader.stopAnimating()
                cell.myPostImageLoader.hidesWhenStopped = true
            }
        }
        
        cell.myPostTitle.text = myPostPake[indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        postId = myPostPake[indexPath.row].postId
        
        performSegue(withIdentifier: "attendees", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "attendees"{
                    let destination = segue.destination as! attendeesViewController
                    destination.postId = postId
            }
        }
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
