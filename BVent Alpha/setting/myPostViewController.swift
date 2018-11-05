//
//  myPostViewController.swift
//  BVent Alpha
//
//  Created by jonathan jordy on 30/10/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class myPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
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
                        
                        
                        
                        self.dispatchDelay(delay: 1.0) {
                            self.table.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                        //print("p")
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                    
                }
            }
            else{
                self.refreshControl.endRefreshing()
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference(fromURL: "https://bvent-alpha-1.firebaseio.com/")
            let groupRef = ref.child("posts").child(myPostPake[indexPath.row].postId)
            let myPostsRef = ref.child("users").child("regular").child(userID!).child("posts").child(myPostPake[indexPath.row].postId)
            // ^^ this only works if the value is set to the firebase uid, otherwise you need to pull that data from somewhere else.
            
            let alert = UIAlertController(title: "Delete", message: "You can't undo this deletion", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Confirm", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button tapped.
                print("Confirm button tapped");
                groupRef.removeValue()
                myPostsRef.removeValue()
                myPostPake.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
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
