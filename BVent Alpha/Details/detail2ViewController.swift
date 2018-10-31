//
//  detail2ViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 26/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class detail2ViewController: UIViewController {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var isi: UILabel!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var tempat: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var jam: UILabel!
    
    var data: [kumpulanData] = kumpulanData.fetch()
    
    var pake: [kumpulanData] = []
    
    var categ: String?
    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
        if categ != "All"{
            pake = data.filter({ (s1) -> Bool in
                return s1.category.contains(categ!)
            })
        }
        else{
            pake = data
        }
        
        self.title = pake[index!].title
        
        //foto.image = pake[index!].image
        
        let url = URL(string: pake[index!].imageUrl)
        
//        let dataImage = try? Data(contentsOf: url!)
//
//        if let imageData = dataImage {
//            foto.image = UIImage(data: imageData)
//        }
        
        ImageService.getImage(withURL: url!) { (image) in
            self.foto.image = image
        }
        
        //time.text = pake[index!].cdown
        
        if (pake[index!].price == ""){
            price.text = "Free"
        }
        else{
            price.text = "Rp. \(pake[index!].price)"
        }
        
        category.text = "in \(pake[index!].category)"
        isi.text = pake[index!].desc
        tempat.text = "Place: \(pake[index!].location)"
        waktu.text = "Date: \(pake[index!].date)"
        jam.text = "Time: \(pake[index!].time)"
        
        if (pake[index!].benefit != ""){
            
            if (pake[index!].certification == true){
                benefit.text = "Benefits: \(pake[index!].benefit), Certificate"
            }
            else{
                benefit.text = "Benefit: \(pake[index!].benefit)"
            }
            
        }
        else{
            
            if (pake[index!].certification == true){
                benefit.text = "Benefit: Certificate"
            }
            else{
                benefit.text = ""
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func message(_ sender: Any) {
        UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func enroll(_ sender: UIButton) {
        
        if (pake[index!].enroll == false){
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newEntry = Enroll(context: context)
            newEntry.ongoingEventTitle = pake[index!].title
            newEntry.ongoingEventPrice = pake[index!].price
            newEntry.ongoingImage = pake[index!].imageUrl as NSObject
            newEntry.ongoingEventBenefit = pake[index!].benefit
            //newEntry.ongoingEventCDown = pake[index!].cdown
            
            if (categ == "Economy"){
                newEntry.ongoingIndex = Int16(index! + 8)
            }
            else if (categ == "Lifestyle"){
                newEntry.ongoingIndex = Int16(index! + 11)
            }
            else if (categ == "Technology"){
                newEntry.ongoingIndex = Int16(index! + 15)
            }
            else if ( categ == "Design"){
                newEntry.ongoingIndex = Int16(index! + 20)
            }
            else if (categ == "Music"){
                newEntry.ongoingIndex = Int16(index! + 25)
            }
            else{
                newEntry.ongoingIndex = Int16(index!)
            }
            
            newEntry.done = false
            
            newEntry.ongoingEventCertification = pake[index!].certification
            //newEntry.ongoingEventPoster = pake[index!].po
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            let alert = UIAlertController(title: "Enrolled!", message: nil, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "You've been enrolled!", message: nil, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
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
    
}
