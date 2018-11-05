//
//  ongoingViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 03/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ongoingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ongoingTable: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        let attributedTitle = NSAttributedString(string: "Fetching My Post(s) Data", attributes: attributes)
        
        refreshControl.addTarget(self, action: #selector(ongoingViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = attributedTitle
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ongoingTable.estimatedRowHeight = 10
        self.ongoingTable.rowHeight = UITableViewAutomaticDimension
        
        val = false
        
        ongoing.removeAll()
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child("regular").child(userID!).child("enroll").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys)!{
                    
                    self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot2) in
                        // Get user value
                        let value2 = snapshot2.value as? NSDictionary
                        
                        kumpulanData.ongoing.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
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
                        
                        ongoingPake = kumpulanData.ongoing
                        
                        self.ongoingTable.reloadData()
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
        
        self.ongoingTable.addSubview(self.refreshControl)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        val = false
        
        ongoing.removeAll()
        
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child("regular").child(userID!).child("enroll").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            
            if (snapshot.exists()){
                
                for postId in (value?.allKeys)!{
                    
                    self.ref.child("posts").child(postId as! String).observeSingleEvent(of: .value, with: { (snapshot2) in
                        // Get user value
                        let value2 = snapshot2.value as? NSDictionary
                        
                        kumpulanData.ongoing.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
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
                        
                        ongoingPake = kumpulanData.ongoing
                        
                        self.ongoingTable.reloadData()
                        
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
        return ongoingPake.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ongoingTable.dequeueReusableCell(withIdentifier: "ongoingCell", for: indexPath) as! ongoingTableViewCell
        
        // Configure the cell...
        cell.ongoingImageLoader.startAnimating()
        
        let url = URL(string: ongoingPake[indexPath.row].imageUrl)
        
//        let dataImage = try? Data(contentsOf: url!)
//
//        if let imageData = dataImage {
//            cell.ongoingEventImage.image = UIImage(data: imageData)
//        }
        
        ImageService.getImage(withURL: url!) { (image) in
            cell.ongoingEventImage.image = image
            
            cell.ongoingImageLoader.stopAnimating()
            cell.ongoingImageLoader.hidesWhenStopped = true
        }
        
        //cell.ongoingEventImage.image = filteredData[indexPath.row].ongoingImage as? UIImage
        cell.ongoingEventTitle.text = ongoingPake[indexPath.row].title
        
        if (ongoingPake[indexPath.row].price == ""){
            cell.ongoingEventPrice.text = "Free"
        }
        else{
            cell.ongoingEventPrice.text = "Rp. \(String(describing: ongoingPake[indexPath.row].price))"
        }
        
        //cell.ongoingEventPrice.text = filteredData[indexPath.row].ongoingEventPrice
        
        if (ongoingPake[indexPath.row].benefit != ""){
            
            if (ongoingPake[indexPath.row].certification == true){
                cell.ongoingEventBenefit.text = "\(String(describing: ongoingPake[indexPath.row].benefit)), Certificate"
            }
            else{
                cell.ongoingEventBenefit.text = "\(String(describing: ongoingPake[indexPath.row].benefit)))"
            }
            
        }
        else{
            
            if (ongoingPake[indexPath.row].certification == true){
                cell.ongoingEventBenefit.text = "Certificate"
            }
            else{
                cell.ongoingEventBenefit.text = ""
            }
        }
        
        //cell.ongoingEventBenefit.text = filteredData[indexPath.row].ongoingEventBenefit
        
        cell.ongoingEventCDown.text =  ongoingPake[indexPath.row].time
        cell.ongoingEventPoster.text = "Himti Binus"/*
         filteredData[indexPath.row].ongoingEventPoster*/
        if (ongoingPake[indexPath.row].done == true){ //REVISI
            cell.done.text = "DONE"
            cell.done.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        else{
            cell.done.text = ""
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
//            // delete item at indexPath
//
//            let item = self.filteredData[indexPath.row]
//            self.context.delete(item)
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()
//
//            self.filteredData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//        }
//        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
//            // delete item at indexPath
//
//            let alert3 = UIAlertController(title: "This Feature Is Not Ready Yet!", message: nil, preferredStyle: .alert)
//            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
//
//            alert3.addAction(action3)
//            self.present(alert3, animated: true, completion: nil)
//
//        }
//
//        delete.backgroundColor = #colorLiteral(red: 0.2293260694, green: 0.4044057131, blue: 0.57067734, alpha: 1)
//        share.backgroundColor = #colorLiteral(red: 0.4780706167, green: 0.6318431497, blue: 0.7779803872, alpha: 1)
//
//        return [delete,share]
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userID = Auth.auth().currentUser?.uid
        ref = Database.database().reference()
        ref.child("users").child("regular").child(userID!).child("enroll").child(ongoingPake[indexPath.row].postId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.val = (snapshot.value as? Bool)!
            
            if (self.val == false){
                self.failed()
            }
            else{
                self.postId = ongoingPake[indexPath.row].postId
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
