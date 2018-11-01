//
//  catViewController.swift
//  BVent home
//
//  Created by jonathan jordy on 18/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class catViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let isi = ["Satu", "Dua", "Tiga", "Empat"]
    let foto = ["1", "2", "3", "4"]
    
    var category: String?
    
    var data: [kumpulanData] = kumpulanData.fetch()
    
    var pake: [kumpulanData] = []
    
    var index: Int?
    
    var name: String = ""
    
    var ref: DatabaseReference!
    
    var loggedInUser: AnyObject?
    var loggedInUserData: NSDictionary?
    
//    var loggedInUser: AnyObject?
//    var loggedInUserData: NSDictionary?
    
    @IBOutlet weak var tabel1: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category
        
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if (category != "All"){
            //print("HELLO")
            pake = data.filter({ (s1) -> Bool in
                return s1.category.contains(category!)
            })
        }
        else{
            pake = data
            //pake = pake.reversed()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pake.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabel1.dequeueReusableCell(withIdentifier: "cat1", for: indexPath) as! catTableViewCell
        
        let url = URL(string: pake[indexPath.row].imageUrl)
        
        ImageService.getImage(withURL: url!) { (image) in
            cell.foto.image = image
        }
        
        //cell.foto.image = pake[indexPath.row].image
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
                cell.benefit.text = "Non - SAT Point"
            }
        }
        
        if (pake[indexPath.row].price == ""){
            cell.price.text = "Free"
        }
        else{
            cell.price.text = "Rp. \(pake[indexPath.row].price)"
        }
        
        cell.location.text = "\(pake[indexPath.row].location)"
        
        ref = Database.database().reference()
        
        ref.child("users").child("regular").child(pake[indexPath.row].poster).child("profile").queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            self.name = value?["fullname"] as? String ?? ""
            cell.poster.text = self.name
            
            print("a")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "details", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // delete item at indexPath
            
            //print("Share")
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
            if identifier == "details"{
                let destination = segue.destination as! detail2ViewController
                destination.index = index
                destination.categ = category
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
