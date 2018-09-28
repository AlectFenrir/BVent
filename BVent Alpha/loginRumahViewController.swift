//
//  rumahViewController.swift
//  BVent home
//
//  Created by jonathan jordy on 25/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class loginRumahViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var data: [kumpulanData] = kumpulanData.fetch()
    
    var pake: [kumpulanData] = []
    
    //pake = data
    
    //var temp: [ambilData] = []
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    @IBOutlet weak var table2: UITableView!
    
    @IBOutlet weak var collection1: UICollectionView!
    
    let main = ["Job", "Economy", "Tech", "Art", "Business", "Health", "Design", "More"]
    
    let cat = ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8"]
    
    var lempar: String? = ""
    var index: Int?
    
    
    var posts = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table2.dataSource = self
        
        pake = data
        
        ref = Database.database().reference()
        
        //        databaseHandle = ref?.child("posts").observe(.childAdded) { (snapshot) in
        //
        //            let fetch = snapshot.value as? [String:Any]
        //
        //            //print(fetch)
        //
        //            let temp = ambilData(fetch: fetch!)
        //
        //            self.pake.append(temp)
        //
        //            print(self.pake[0].category)
        //
        //        }
        
        collection1?.backgroundColor = .clear
        collection1?.contentInset = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        
        // Do any additional setup after loading the view.
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rumahCell", for: indexPath) as! loginRumahCollectionViewCell
        
        cell.foto.image = UIImage(named: cat[indexPath.row])
        cell.cat.text = main[indexPath.row]
        //cell.cat.text = main[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if tableView == table2{
        //
        //        }
        return 125
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pake.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table2.dequeueReusableCell(withIdentifier: "rumahCell2", for: indexPath) as! loginRumahTableViewCell
        
        cell.foto.image = pake[indexPath.row].image
        cell.judul.text = pake[indexPath.row].name
        
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
        
        //cell.cDown.text = pake[indexPath.row].cdown
        cell.poster.text = ""
        
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
