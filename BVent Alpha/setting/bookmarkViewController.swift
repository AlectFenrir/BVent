//
//  bookmarkViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 05/11/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class bookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bookmarkTable: UITableView!

    var ongoing: [Enroll] = []
    var selectedIndex: Int!
    
    var filteredData: [Enroll] = []
    var postId: String = ""
    
    var deleteIndex: Int?
    var validation: Int?
    
    var ref: DatabaseReference!
    
    var val: Bool = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Fetching Bookmarked Event Data", attributes: attributes)
        
        refreshControl.addTarget(self, action: #selector(bookmarkViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = attributedTitle
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bookmarkTable.estimatedRowHeight = 10
        self.bookmarkTable.rowHeight = UITableViewAutomaticDimension
        
        val = false
        
        //ongoing.removeAll()
        kumpulanData.bookmark.removeAll()
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child("regular").child(userID!).child("bookmark").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys)!{
                    
                    self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot2) in
                        // Get user value
                        let value2 = snapshot2.value as? NSDictionary
                        
                        kumpulanData.bookmark.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
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
                        
                        bookmarkPake = kumpulanData.bookmark
                        
                        self.bookmarkTable.reloadData()
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
        
        self.bookmarkTable.addSubview(self.refreshControl)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        val = false
        
        //ongoing.removeAll()
        kumpulanData.bookmark.removeAll()
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child("regular").child(userID!).child("bookmark").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys)!{
                    
                    self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot2) in
                        // Get user value
                        let value2 = snapshot2.value as? NSDictionary
                        
                        kumpulanData.bookmark.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
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
                        
                        bookmarkPake = kumpulanData.bookmark
                        
                        
                        
                        self.dispatchDelay(delay: 1.0) {
                            self.bookmarkTable.reloadData()
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
        return bookmarkPake.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookmarkTable.dequeueReusableCell(withIdentifier: "bookmarkCell", for: indexPath) as! bookmarkTableViewCell
        
        // Configure the cell...
        cell.bookmarkImageLoader.startAnimating()
        
        let url = URL(string: bookmarkPake[indexPath.row].imageUrl)
        ImageService.getImage(withURL: url!) { (image) in
            cell.bookmarkPhoto.image = image
            
            cell.bookmarkImageLoader.stopAnimating()
            cell.bookmarkImageLoader.hidesWhenStopped = true
        }
        
        //cell.ongoingEventImage.image = filteredData[indexPath.row].ongoingImage as? UIImage
        cell.bookmarkTitle.text = bookmarkPake[indexPath.row].title
        
        if (bookmarkPake[indexPath.row].price == ""){
            cell.bookmarkPrice.text = "Free"
        }
        else{
            cell.bookmarkPrice.text = "Rp. \(String(describing: bookmarkPake[indexPath.row].price))"
        }
        
        //cell.ongoingEventPrice.text = filteredData[indexPath.row].ongoingEventPrice
        
        if (bookmarkPake[indexPath.row].benefit != ""){
            
            if (bookmarkPake[indexPath.row].certification == true){
                cell.bookMarkBenefit.text = "\(String(describing: bookmarkPake[indexPath.row].benefit)), Certificate"
            }
            else{
                cell.bookMarkBenefit.text = "\(String(describing: bookmarkPake[indexPath.row].benefit)))"
            }
            
        }
        else{
            
            if (bookmarkPake[indexPath.row].certification == true){
                cell.bookMarkBenefit.text = "Certificate"
            }
            else{
                cell.bookMarkBenefit.text = ""
            }
        }
        
        //cell.ongoingEventBenefit.text = filteredData[indexPath.row].ongoingEventBenefit
        
        cell.bookmarkTime.text =  bookmarkPake[indexPath.row].time
        cell.bookmarkPoster.text = "Himti Binus"/*
         filteredData[indexPath.row].ongoingEventPoster*/
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            
            let userID = Auth.auth().currentUser?.uid
            let ref = Database.database().reference(fromURL: "https://bvent-alpha-1.firebaseio.com/")
            let groupRef = ref.child("users").child("regular").child(userID!).child("bookmark").child(bookmarkPake[indexPath.row].postId)
            // ^^ this only works if the value is set to the firebase uid, otherwise you need to pull that data from somewhere else.
            
            let alert = UIAlertController(title: "Delete", message: "You can't undo this deletion", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Confirm", style: .default) { (action:UIAlertAction!) in
                
                // Code in this block will trigger when OK button tapped.
                print("Confirm button tapped");
                groupRef.removeValue()
                bookmarkPake.remove(at: indexPath.row)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("users").child("regular").child(userID!).child("bookmark").child(bookmarkPake[indexPath.row].postId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.val = (snapshot.value as? Bool)!
            
            if (self.val == false){
                self.failed()
            }
            else{
                self.postId = bookmarkPake[indexPath.row].postId
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
        performSegue(withIdentifier: "bookmarkDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "bookmarkDetails"{
                let destination = segue.destination as! detail3ViewController
                destination.postId = postId
            }
        }
    }

}
