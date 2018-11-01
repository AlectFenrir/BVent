//
//  ongoingViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 03/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import CoreData

class ongoingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var ongoingTable: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var ongoing: [Enroll] = []
    var selectedIndex: Int!
    
    var filteredData: [Enroll] = []
    var index: Int?
    
    var deleteIndex: Int?
    var validation: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ongoingTable.estimatedRowHeight = 10
        self.ongoingTable.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func fetchData()
    {
        do
        {
            ongoing = try context.fetch(Enroll.fetchRequest())
            filteredData = ongoing
            DispatchQueue.main.async {
                self.ongoingTable.reloadData()
            }
        }
        catch
        {
            print("Couldn't Fetch Data")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ongoingTable.dequeueReusableCell(withIdentifier: "ongoingCell", for: indexPath) as! ongoingTableViewCell
        
        // Configure the cell...
        cell.ongoingImageLoader.startAnimating()
        
        let url = URL(string: filteredData[indexPath.row].ongoingImage as! String)
        
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
        cell.ongoingEventTitle.text = filteredData[indexPath.row].ongoingEventTitle
        
        if (filteredData[indexPath.row].ongoingEventPrice == ""){
            cell.ongoingEventPrice.text = "Free"
        }
        else{
            cell.ongoingEventPrice.text = "Rp. \(String(describing: filteredData[indexPath.row].ongoingEventPrice!))"
        }
        
        //cell.ongoingEventPrice.text = filteredData[indexPath.row].ongoingEventPrice
        
        if (filteredData[indexPath.row].ongoingEventBenefit != ""){
            
            if (filteredData[indexPath.row].ongoingEventCertification == true){
                cell.ongoingEventBenefit.text = "\(String(describing: filteredData[indexPath.row].ongoingEventBenefit!)), Certificate"
            }
            else{
                cell.ongoingEventBenefit.text = "\(String(describing: filteredData[indexPath.row].ongoingEventBenefit!)))"
            }
            
        }
        else{
            
            if (filteredData[indexPath.row].ongoingEventCertification == true){
                cell.ongoingEventBenefit.text = "Certificate"
            }
            else{
                cell.ongoingEventBenefit.text = ""
            }
        }
        
        //cell.ongoingEventBenefit.text = filteredData[indexPath.row].ongoingEventBenefit
        
        cell.ongoingEventCDown.text =  filteredData[indexPath.row].ongoingEventCDown
        print(filteredData[indexPath.row].ongoingIndex)
        cell.ongoingEventPoster.text = "Himti Binus"/*
         filteredData[indexPath.row].ongoingEventPoster*/
        if (filteredData[indexPath.row].done == true){
            cell.done.text = "DONE"
            cell.done.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }
        else{
            cell.done.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            
            let item = self.filteredData[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // delete item at indexPath
            
            let alert3 = UIAlertController(title: "This Feature Is Not Ready Yet!", message: nil, preferredStyle: .alert)
            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert3.addAction(action3)
            self.present(alert3, animated: true, completion: nil)
            
        }
        
        delete.backgroundColor = #colorLiteral(red: 0.2293260694, green: 0.4044057131, blue: 0.57067734, alpha: 1)
        share.backgroundColor = #colorLiteral(red: 0.4780706167, green: 0.6318431497, blue: 0.7779803872, alpha: 1)
        
        return [delete,share]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (filteredData[indexPath.row].done == true){
            let alert = UIAlertController(title: "This Event is Done Already!", message: nil, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else{
            index = Int(filteredData[indexPath.row].ongoingIndex)
            
            performSegue(withIdentifier: "ongoingDetails", sender: nil)
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "ongoingDetails"{
                let destination = segue.destination as! detail5ViewController
                destination.index = index
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
