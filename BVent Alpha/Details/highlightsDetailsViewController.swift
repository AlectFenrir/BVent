//
//  highlightsDetailsViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 17/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase
import LocalAuthentication
import EventKit

class highlightsDetailsViewController: UIViewController {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventPoster: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var eventBenefits: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    var data: [kumpulanData] = kumpulanData.fetch()
    
    var pake: [kumpulanData] = []
    
    var index: Int?
    
    var phoneNumber: String = ""
    
    var ref: DatabaseReference!
    
    var val = false
    
    var posterId: String = ""
    
    var userLempar: User!
    
    let eventStore: EKEventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        val = false
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
        pake = data
        
        eventTitle.text = pake[index!].title
        
        //foto.image = pake[index!].image
        
        //detail1ImageLoader.startAnimating()
        
        let url = URL(string: pake[index!].imageUrl)
        ImageService.getImage(withURL: url!) { (image) in
            self.eventImage.image = image
            
//            self.detail1ImageLoader.stopAnimating()
//            self.detail1ImageLoader.hidesWhenStopped = true
        }
        
        //time.text = pake[index!].cdown
        
        if (pake[index!].price == ""){
            eventPrice.text = "Free"
        }
        else{
            eventPrice.text = "Rp. \(pake[index!].price)"
        }
        
        eventDescription.text = pake[index!].desc
        eventLocation.text = "Place: \(pake[index!].location)"
        eventDate.text = "Date: \(pake[index!].date)"
        eventTime.text = "Time: \(pake[index!].time)"
        
        if (pake[index!].benefit != ""){
            
            if (pake[index!].certification == true){
                eventBenefits.text = "Benefits: \(pake[index!].benefit), Certificate"
            }
            else{
                eventBenefits.text = "Benefit: \(pake[index!].benefit)"
            }
            
        }
        else{
            
            if (pake[index!].certification == true){
                eventBenefits.text = "Benefit: Certificate"
            }
            else{
                eventBenefits.text = ""
            }
        }
        
        
        
        phoneNumber = pake[index!].cp
        
//        saveBtn.layer.cornerRadius = 7
//        saveBtn.clipsToBounds = true
//        saveBtn.layer.borderWidth = 0.25
//        saveBtn.layer.borderColor = UIColor.black.cgColor
//
//        enrollBtn.layer.cornerRadius = 7
//        enrollBtn.clipsToBounds = true
//        enrollBtn.layer.borderWidth = 0.25
//        enrollBtn.layer.borderColor = UIColor.black.cgColor
//
//        decsBtn.layer.cornerRadius = 7
//        decsBtn.clipsToBounds = true
//        decsBtn.layer.borderWidth = 0.25
//        decsBtn.layer.borderColor = UIColor.white.cgColor
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromBottom
        //view.backgroundColor = UIColor.clear
        //view.window?.backgroundColor = UIColor.clear
        //view.window?.isOpaque = true
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "chat segue"{
                
                let destination = segue.destination as! ChatViewController
                destination.currentUser = self.userLempar
                
            }
        }
    }

}
