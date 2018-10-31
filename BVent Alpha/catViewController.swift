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
    let text = ["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb", "cccccccccccccccccccccccccccccccccccc", "ddddddddddddddddddddddddddddddddddddddd"]
    
    var category: String?
    
    var data: [kumpulanData] = kumpulanData.fetch()
    
    var pake: [kumpulanData] = []
    
    var index: Int?
    
    var ref: DatabaseReference?
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
        
        //tabel1.contentSize = CGSizeMake(tabel1.frame.size.width, tabel1.contentSize.height)
        
        //tabel1.
        
        //self.view.backgroundColor = #colorLiteral(red: 0.7614244819, green: 0.84412992, blue: 0.999927938, alpha: 1)
        //tabel1.backgroundColor = .clear
        
        //tabel1.frame = CGRect(x: tabel1.frame.origin.x, y: tabel1.frame.origin.y, width: tabel1.frame.size.width, height: 30)
        //tabel1.frame.height = 30
        
        //tabel1.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 30)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pake.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //let poto = UIImage(named: foto[indexPath.row])
        
        return 120 //(poto?.size.height)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabel1.dequeueReusableCell(withIdentifier: "cat1", for: indexPath) as! catTableViewCell
        
        let url = URL(string: pake[indexPath.row].imageUrl)
        
//        let dataImage = try? Data(contentsOf: url!)
//
//        if let imageData = dataImage {
//            cell.foto.image = UIImage(data: imageData)
//        }
        
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
        
        //cell.cDown.text = pake[indexPath.row].cdown
        cell.location.text = "\(pake[indexPath.row].location)"
        cell.poster.text = "\(pake[indexPath.row].poster)"
//        cell.configure(poster: self.loggedInUserData!["fullname"] as! String)
        //cell.bg.backgroundColor = .clear
        //cell.foto.frame = CGRect(x: 0, y: 0, width: cell.foto.frame.size.width, height: cell.foto.frame.size.height)
        
        //cell.bg.frame.size = CGRect(x: cell.bg.frame.origin.x, y: cell.bg.frame.origin.y, width: cell.bg.frame.size.width, height: 200)
        
        //cell.foto.frame = CGRect(x: 10, y: 5, width: cell.foto.frame.size.width, height: cell.foto.frame.size.height)
        
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
