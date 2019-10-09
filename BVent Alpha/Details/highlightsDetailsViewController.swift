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

    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var eventImage: WebImageView! {
        didSet {
            eventImage.configuration.placeholderImage = UIImage(named: "lightGray")
            eventImage.configuration.animationOptions = .transitionCrossDissolve
        }
    }
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventPoster: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var eventBenefits: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    
    let barHeight: CGFloat = 50
    var topAnchorContraint: NSLayoutConstraint!
    
    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
//        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
//        newImageView.addGestureRecognizer(swipe)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    lazy var leftButton: UIBarButtonItem = {
        //let image = UIImage.init(named: "default profile")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(title: "Close", style: .plain, target: self, action: #selector(highlightsDetailsViewController.showHome))
        return button
    }()
    
    func customization()  {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //NavigationBar customization
        let navigationTitleFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: navigationTitleFont, NSAttributedStringKey.foregroundColor: UIColor.black]
        // notification setup
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.pushToUserMesssages(notification:)), name: NSNotification.Name(rawValue: "showUserMessages"), object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.showEmailAlert), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        //right bar button
        let icon = UIImage.init(named: "message")?.withRenderingMode(.alwaysOriginal)
        let rightButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(highlightsDetailsViewController.showConversations))
        self.navigationItem.rightBarButtonItem = rightButton
        //left bar button image fetching
        self.navigationItem.leftBarButtonItem = self.leftButton
        //self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        //        if let id = Auth.auth().currentUser?.uid {
        //            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
        //                let image = user.profilePic
        //                let contentSize = CGSize.init(width: 30, height: 30)
        //                UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
        //                let _  = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14).addClip()
        //                image.draw(in: CGRect(origin: CGPoint.zero, size: contentSize))
        //                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14)
        //                path.lineWidth = 2
        //                UIColor.white.setStroke()
        //                path.stroke()
        //                let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
        //                UIGraphicsEndImageContext()
        //                DispatchQueue.main.async {
        //                    weakSelf?.leftButton.image = finalImage
        //                    weakSelf = nil
        //                }
        //            })
        //        }
    }
    
    @objc func showConversations() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Conversations") as! UIViewController
        self.show(vc, sender: nil)
        //self.present(vc, animated: true, completion: nil)
    }
    
    @objc func showHome() {
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
        //customization()
        
        val = false
        
        //self.navigationController?.navigationBar.prefersLargeTitles = false
        
        pake = data
        
        eventTitle.text = pake[index!].title
        
        //foto.image = pake[index!].image
        
        //detail1ImageLoader.startAnimating()
        
        let url = URL(string: pake[index!].imageUrl)
        eventImage.load(url: url!)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputBar.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.view.transform = CGAffineTransform.identity
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        //self.tabBarController?.tabBar.isHidden = false
//        //self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        showHome()
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
