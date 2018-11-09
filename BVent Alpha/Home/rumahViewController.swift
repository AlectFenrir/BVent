//
//  rumahViewController.swift
//  BVent home
//
//  Created by jonathan jordy on 25/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import Firebase

class rumahViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {
    
    
    //var temp: [ambilData] = []
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var loggedInUser: AnyObject?
    var loggedInUserData: NSDictionary?
    var storageRef: StorageReference?
    
    @IBOutlet weak var table2: UITableView!
    
    let main = ["All", "Business", "Technology", "Economy", "Lifestyle", "Design", "Music", "More"]
    
    let cat = ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8"]
    
    var lempar: String? = ""
    var index: Int?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Fetching Event Data", attributes: attributes)
        
        refreshControl.addTarget(self, action: #selector(rumahViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = attributedTitle
        refreshControl.attributedTitle = NSAttributedString(string:"Last updated on " + NSDate().description)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table2.dataSource = self
        
        pake.removeAll()
        
        kumpulanData.datas.removeAll()
        
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
            
            kumpulanData.datas.insert(kumpulanData(benefit: temp.benefit, bookmark: temp.bookmark, category: temp.category, certification: temp.certification, confirmCode: temp.confirmCode, cp: temp.cp, date: temp.date, desc: temp.desc, done: temp.done, enroll: temp.enroll, location: temp.location, price: temp.price, sat: temp.sat, time: temp.time, title: temp.title, timestamp: temp.timestamp, poster: temp.poster, imageUrl: temp.imageUrl, postId: snapshot.key), at: 0)
                
                self.loggedInUser = Auth.auth().currentUser
                
                if temp.poster == self.loggedInUser?.uid{
                self.ref.child("users").child("regular").child(self.loggedInUser!.uid).child("posts").child(snapshot.key).setValue(true)
                    
                }
            
                pake = kumpulanData.datas
                //pake.sort(by: {$0.date > $1.date})
                
                self.table2.reloadData()
        }
        
        if UIApplication.shared.keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.available
        {
            registerForPreviewing(with: self, sourceView: table2)
            
        }
        //self.table2.addSubview(self.refreshControl)
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        pake.removeAll()
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        ref.child("posts").queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? [String:Any]
            
            let temp = ambilData(fetch: value!)
            
            kumpulanData.datas.insert(kumpulanData(benefit: temp.benefit, bookmark: temp.bookmark, category: temp.category, certification: temp.certification, confirmCode: temp.confirmCode, cp: temp.cp, date: temp.date, desc: temp.desc, done: temp.done, enroll: temp.enroll, location: temp.location, price: temp.price, sat: temp.sat, time: temp.time, title: temp.title, timestamp: temp.timestamp, poster: temp.poster, imageUrl: temp.imageUrl, postId: snapshot.key), at: 0)
            
            self.loggedInUser = Auth.auth().currentUser
            
            if temp.poster == self.loggedInUser!.uid{
                self.ref.child("users").child("regular").child(self.loggedInUser!.uid).child("posts").child(snapshot.key).setValue(true)
                
            }
            
            pake = kumpulanData.datas
            //pake.sort(by: {$0.date > $1.date})
            
            self.dispatchDelay(delay: 2.0) {
                self.table2.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func dispatchDelay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: closure)
    }
    
    func detailViewController(for index: Int) -> detail1ViewController {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail1ViewController") as? detail1ViewController else {
            fatalError("Couldn't load detail view controller")
        }
        
        vc.index = index
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = table2.indexPathForRow(at: location) {
            previewingContext.sourceRect = table2.rectForRow(at: indexPath)
            return detailViewController(for: indexPath.row)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rumahCell", for: indexPath) as! rumahCollectionViewCell
        
        cell.foto.image = UIImage(named: cat[indexPath.row])
        cell.cat.text = main[indexPath.row]
        //cell.cat.text = main[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 125
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pake.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = table2.dequeueReusableCell(withIdentifier: "rumahCell2", for: indexPath) as! rumahTableViewCell
        
        cell.homeImageLoader.startAnimating()
        
        let url = URL(string: pake[indexPath.row].imageUrl)
        ImageService.getImage(withURL: url!) { (image) in
        cell.foto.image = image
            
            cell.homeImageLoader.stopAnimating()
            cell.homeImageLoader.hidesWhenStopped = true
            
        }
        
        cell.judul.text = pake[indexPath.row].title
        
        if (pake[indexPath.row].benefit != ""){
            
            if (pake[indexPath.row].certification == true){
                cell.benefit.text = "\(pake[indexPath.row].benefit), Certificate"
            }
            else{
                cell.benefit.text = "\(pake[indexPath.row].benefit)"
            }
            
        }
        else{
            
            if (pake[indexPath.row].certification == true){
                cell.benefit.text = "Certificate"
            }
            else{
                cell.benefit.text = ""
            }
        }
        
        if (pake[indexPath.row].price == ""){
            cell.price.text = "Free"
        }
        else{
            cell.price.text = "Rp. \(pake[indexPath.row].price)"
        }
        
        cell.location.text = pake[indexPath.row].location
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        guard let dateInShow = pake[indexPath.row].date.date else {return cell}
        cell.poster.text = formatter.string(from: dateInShow)
        
        //cell.configure(poster: self.loggedInUserData!["fullname"] as! String)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        index = indexPath.row
        performSegue(withIdentifier: "details", sender: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (main[indexPath.row] != "All"){
            lempar = main[indexPath.row]
        }
        else{
            lempar = "All"
        }
        
        performSegue(withIdentifier: "category", sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // delete item at indexPath
            
            let alert3 = UIAlertController(title: "This Feature Is Not Ready Yet!", message: nil, preferredStyle: .alert)
            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert3.addAction(action3)
            self.present(alert3, animated: true, completion: nil)
            
        }
        
        share.backgroundColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1.0)
        
        
        return [share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "category"{
                if (lempar != "All"){
                    let destination = segue.destination as! catViewController
                    destination.category = lempar
                }
                else{
                    let destination = segue.destination as! catViewController
                    destination.category = "All"
                }
            }
            else if identifier == "details"{
                let destination = segue.destination as! detail1ViewController
                destination.index = index
            }
        }
    }
}


extension String{
    var date : Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "id_ID")
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.date(from: self)
    }
}
