//
//  detail5ViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 03/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class detail5ViewController: UIViewController {
    
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var tempat: UILabel!
    @IBOutlet weak var waktu: UILabel!
    @IBOutlet weak var jam: UILabel!
    @IBOutlet weak var isi: UILabel!
    @IBOutlet weak var benefit: UILabel!
    
    var video = AVCaptureVideoPreviewLayer()
    
    var deleteIndex: Int?
    var validation: Bool = false
    
    
    //var point: sat = sat.fetch()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var SATPoint: [Enroll] = []
//    var sat: Sat?
//    var filteredData: [Enroll] = []
    
    var finalPoint: Int = 0
    
    var data: [kumpulanData] = kumpulanData.fetch()
    var pake: [kumpulanData] = []
    var categ: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pake = data
        
        print("WOWO: \(index!)")
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.title = pake[index!].title
        
        let url = URL(string: pake[index!].imageUrl)
        
        let dataImage = try? Data(contentsOf: url!)
        
        if let imageData = dataImage {
            foto.image = UIImage(data: imageData)
        }
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        fetchData()
    //    }
    
    //    func fetchData()
    //    {
    //        do
    //        {
    //            SATPoint = try context.fetch(Enroll.fetchRequest())
    //            filteredData = SATPoint
    //            DispatchQueue.main.async {
    //
    //            }
    //        }
    //        catch
    //        {
    //            print("Couldn't Fetch Data")
    //        }
    //    }
    
    @IBAction func confirmAttendance(_ sender: UIButton) {
        if (self.validation == false){
            let alert = UIAlertController(title: "Verification Code", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Code"
            }
            
            
            let action = UIAlertAction(title: "Confirm", style: .default) { (_) in
                
                if alert.textFields!.first!.text! == self.pake[self.index!].confirmCode{
                    
                    //if (self.validation == false)
                    
                    point = point + self.pake[self.index!].sat
                    //print(point)
                    
                    let alert1 = UIAlertController(title: "Verified!", message: nil, preferredStyle: .alert)
                    
                    let action1 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
                    
                    alert1.addAction(action1)
                    self.present(alert1, animated: true, completion: nil)
                    
                    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Enroll")
                    
                    let predicate = NSPredicate(format: "done = '\(false)'")
                    fetchRequest.predicate = predicate
                    do
                    {
                        let test = try self.context.fetch(fetchRequest)
                        if test.count == 1
                        {
                            let objectUpdate = test[0] as! NSManagedObject
                            objectUpdate.setValue(true, forKey: "done")
                            do{
                                try self.context.save()
                            }
                            catch
                            {
                                print(error)
                            }
                        }
                    }
                    catch
                    {
                        print(error)
                    }
                    
                    self.pake[self.index!].enroll = true
                    self.validation = true
                    
                    
                    //print(self.filteredData[self.index!].done)
                    
                    //Sat.setValue(self.SATPoint, forKey: "Sat")
                    //self.performSegue(withIdentifier: "delete", sender: nil)
                }
                else{
                    let alert2 = UIAlertController(title: "Wrong Code!!", message: nil, preferredStyle: .alert)
                    
                    let action2 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
                    
                    alert2.addAction(action2)
                    self.present(alert2, animated: true, completion: nil)
                    self.validation = false
                }
                
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            //deleteIndex = index
            performSegue(withIdentifier: "delete", sender: nil)
        }
        else{
            //print("BEGO")
            
            let alert3 = UIAlertController(title: "You've verified already!", message: nil, preferredStyle: .alert)
            let action3 = UIAlertAction(title: "Dismiss", style: .default) { (_) in}
            
            alert3.addAction(action3)
            self.present(alert3, animated: true, completion: nil)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "delete"{
                let destination = segue.destination as! ongoingViewController
                destination.deleteIndex = self.deleteIndex
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

