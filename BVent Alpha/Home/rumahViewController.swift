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

class rumahViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate {
    
    
    //var temp: [ambilData] = []
    var ref: DatabaseReference!
    var databaseHandle: DatabaseHandle?
    var loggedInUser: AnyObject?
    var loggedInUserData: NSDictionary?
    var storageRef: StorageReference?
    
    @IBOutlet weak var table2: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let main = ["All", "Business", "Technology", "Economy", "Lifestyle", "Design", "Music", "More"]
    let cat = ["cat1", "cat2", "cat3", "cat4", "cat5", "cat6", "cat7", "cat8"]
    
    var lempar: String? = ""
    var index: Int?
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var itemSize = CGSize(width: 0, height: 0)
    var highlights: Bool = false
    //var appStoreItems = [highlightsPake]
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        let attributedTitle = NSAttributedString(string: "Fetching Event Data", attributes: attributes)

        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        refreshControl.attributedTitle = attributedTitle
        refreshControl.attributedTitle = NSAttributedString(string:"Last updated on " + NSDate().description)
        refreshControl.sizeToFit()

        return refreshControl
    }()
    
    lazy var leftButton: UIBarButtonItem = {
        let image = UIImage.init(named: "default profile")?.withRenderingMode(.alwaysOriginal)
        let button  = UIBarButtonItem.init(image: image, style: .plain, target: self, action: #selector(rumahViewController.showProfile))
        return button
    }()
    
    func customization()  {
        //left bar button image fetching
        navigationItem.leftBarButtonItem = self.leftButton
        //self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        if let id = Auth.auth().currentUser?.uid {
            User.info(forUserID: id, completion: { [weak weakSelf = self] (user) in
                let image = user.profilePic
                let contentSize = CGSize.init(width: 30, height: 30)
                UIGraphicsBeginImageContextWithOptions(contentSize, false, 0.0)
                let _  = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14).addClip()
                image.draw(in: CGRect(origin: CGPoint.zero, size: contentSize))
                let path = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.zero, size: contentSize), cornerRadius: 14)
                path.lineWidth = 0
                UIColor.white.setStroke()
                path.stroke()
                let finalImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysOriginal)
                UIGraphicsEndImageContext()
                DispatchQueue.main.async {
                    weakSelf?.leftButton.image = finalImage
                    weakSelf = nil
                }
            })
        }
    }
    
    @objc func showProfile() {
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "account")
        let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
        present(navController, animated:true, completion: nil)
    }
    
//    func fetchHighlights() {
//        automaticallyAdjustsScrollViewInsets = false
//
////        highlightsPake.removeAll()
////        kumpulanData.highlights.removeAll()
//
////        ref = Database.database().reference()
////        ref.keepSynced(true)
//////        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
//////            let value = snapshot.value as? NSDictionary
//////
//////            if (snapshot.exists()) {
//////                for highlights in (value?.allKeys(for: true))! {
////                    ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot2) in
////                        let value2 = snapshot2.value as? NSDictionary
////
//////                            let appStoreItem = AppStoreItem()
//////                            appStoreItem.imageName = "example-\(index).jpg"
//////                            appStoreItems.append(appStoreItem)
////                        kumpulanData.highlights.append(kumpulanData(benefit: value2?["benefit"] as? String ?? "",
////                                                                    bookmark: value2?["bookmark"] as? Bool ?? false,
////                                                                    category: value2?["category"] as? String ?? "",
////                                                                    certification: value2?["certification"] as? Bool ?? false,
////                                                                    confirmCode: value2?["confirmCode"] as? String ?? "",
////                                                                    cp: value2?["cp"] as? String ?? "",
////                                                                    date: value2?["date"] as? String ?? "",
////                                                                    desc: value2?["desc"] as? String ?? "",
////                                                                    done: value2?["done"] as? Bool ?? false,
////                                                                    enroll: value2?["enroll"] as? Bool ?? false,
////                                                                    location: value2?["location"] as? String ?? "",
////                                                                    price: value2?["price"] as? String ?? "",
////                                                                    sat: value2?["sat"] as? Int ?? 0,
////                                                                    time: value2?["time"] as? String ?? "",
////                                                                    title: value2?["title"] as? String ?? "",
////                                                                    timestamp: value2?["timestamp"] as? String ?? "",
////                                                                    poster: value2?["poster"] as? String ?? "",
////                                                                    imageUrl: value2?["imageUrl"] as? String ?? "",
////                                                                    postId: snapshot2.key,
////                                                                    highlights: value2?["highlights"] as? Bool ?? true))
////
////                        highlightsPake = kumpulanData.highlights
//
//                        self.collectionView.dataSource = self
//                        self.collectionView.delegate = self
//                        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                            layout.minimumLineSpacing = 0
//                            layout.minimumInteritemSpacing = 0
//                            layout.sectionInset = self.sectionInsets
//                            layout.scrollDirection = .horizontal
//                        }
//                        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                        self.collectionView.isPagingEnabled = false
//                        self.view.layoutIfNeeded()
//
//                        let width = self.collectionView.bounds.size.width
//                        let height = self.collectionView.bounds.size.height // width * (9/16)
//                        self.itemSize = CGSize(width: width, height: height)
//                        print("itemSize: \(self.itemSize)")
//                        //self.collectionViewHeight.constant = height
//                        self.view.layoutIfNeeded()
//                        self.collectionView.reloadData()
////                    })
////                }
////            }
////        })
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customization()
        
        table2.dataSource = self
        table2.delegate = self
        
//        pake.removeAll()
//        kumpulanData.datas.removeAll()
//
//        ref = Database.database().reference()
//        ref.keepSynced(true)
//
//        //let postsImageRef = storageRef?.child("posts")
//        //self.postsRef.keepSynced(true)
//
////        self.loggedInUser = Auth.auth().currentUser
////
////        self.ref?.child("users").child("regular").child(self.loggedInUser!.uid).child("profile").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
////
////            self.loggedInUserData = snapshot.value as? NSDictionary
//
//        self.databaseHandle = self.ref.child("posts").queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
//
//                let value = snapshot.value as? [String:Any]
//
//                let temp = ambilData(fetch: value!)
//
//            kumpulanData.datas.insert(kumpulanData(benefit: temp.benefit, bookmark: temp.bookmark, category: temp.category, certification: temp.certification, confirmCode: temp.confirmCode, cp: temp.cp, date: temp.date, desc: temp.desc, done: temp.done, enroll: temp.enroll, location: temp.location, price: temp.price, sat: temp.sat, time: temp.time, title: temp.title, timestamp: temp.timestamp, poster: temp.poster, imageUrl: temp.imageUrl, postId: snapshot.key, highlights: temp.highlights), at: 0)
//
//                self.loggedInUser = Auth.auth().currentUser
//
//                if temp.poster == self.loggedInUser?.uid{
//                self.ref.child("users").child("regular").child(self.loggedInUser!.uid).child("posts").child(snapshot.key).setValue(true)
//
//                }
//
//                pake = kumpulanData.datas
//                //pake.sort(by: {$0.date > $1.date})
//
//
//        }
        
        table2.reloadData()
        
        if #available(iOS 10.0, *) {
            table2.refreshControl = refreshControl
        } else {
            table2.addSubview(refreshControl)
        }
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.isHidden = false
//    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        pake.removeAll()
        kumpulanData.datas.removeAll()
        
        highlightsPake.removeAll()
        kumpulanData.highlights.removeAll()
        
        nearbyPake.removeAll()
        kumpulanData.nearby.removeAll()
        
        upcomingPake.removeAll()
        kumpulanData.upcoming.removeAll()
        
        ref = Database.database().reference()
        ref.keepSynced(true)
        
        ref.child("posts").queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
            
            let value = snapshot.value as? [String:Any]
            
            let temp = ambilData(fetch: value!)
            
            kumpulanData.datas.insert(kumpulanData(benefit: temp.benefit, bookmark: temp.bookmark, category: temp.category, certification: temp.certification, confirmCode: temp.confirmCode, cp: temp.cp, date: temp.date, desc: temp.desc, done: temp.done, enroll: temp.enroll, location: temp.location, price: temp.price, sat: temp.sat, time: temp.time, title: temp.title, timestamp: temp.timestamp, poster: temp.poster, imageUrl: temp.imageUrl, postId: snapshot.key, highlights: temp.highlights), at: 0)
            
            self.loggedInUser = Auth.auth().currentUser
            
            if temp.poster == self.loggedInUser!.uid{
                self.ref.child("users").child("regular").child(self.loggedInUser!.uid).child("posts").child(snapshot.key).setValue(true)
                
            }
            
            pake = kumpulanData.datas
            highlightsPake = kumpulanData.datas
            nearbyPake = kumpulanData.datas
            upcomingPake = kumpulanData.datas
            //pake.sort(by: {$0.date > $1.date})
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [refreshControl] in
//                self.table2.reloadData()
//                self.updateViewConstraints()
//                refreshControl.endRefreshing()
//            }
            
            self.dispatchDelay(delay: 1.0) {
                self.table2.reloadData()
                self.updateViewConstraints()
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

    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("appStoreItems.count: \(pake.count)")
//        return pake.count
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    @available(iOS 6.0, *)
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "rumahCell", for: indexPath) as! rumahCollectionViewCell
//        let url = URL(string: pake[indexPath.row].imageUrl)
//
////        cell.cornerRadius = 9
//        ImageService.getImage(withURL: url!) { (image) in
//            cell.foto.image = image
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
//    }
//
//    //MARK: flowlayout
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//
//        return sectionInsets.left
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return itemSize
//    }
//
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let pageWidth = itemSize.width
//        targetContentOffset.pointee = scrollView.contentOffset
//        var factor: CGFloat = 0.5
//        if velocity.x < 0 {
//            factor = -factor
//            print("swipe right")
//        } else {
//            print("swipe left")
//        }
//
//        var index = Int( round((scrollView.contentOffset.x/pageWidth)+factor) )
//        if index < 0 {
//            index = 0
//        }
//        if index > pake.count-1 {
//            index = pake.count-1
//        }
//        let indexPath = IndexPath(row: index, section: 0)
//        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
        }
        else if indexPath.section == 1 {
            return 305
        }
        else {
            return 1000
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return ""
        }
        else if section == 1{
            return ""
        }
        else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else if section == 1{
            return 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell2 = table2.dequeueReusableCell(withIdentifier: "rumahCell2"/*, for: indexPath*/) as! rumahTableViewCell
        let cell3 = table2.dequeueReusableCell(withIdentifier: "rumahCell3"/*, for: indexPath*/) as! highlightsTableViewCell
        let cell4 = table2.dequeueReusableCell(withIdentifier: "rumahCell4") as! upcomingTableViewCell2
        
        if indexPath.section == 0{
            if cell3.highlightsCollectionController == nil {
                let highlightsCollectionController = storyboard?.instantiateViewController(withIdentifier: "highlightsCollection") as! highlightsCollectionViewController
                cell3.highlightsCollectionController = highlightsCollectionController
                let highlightsCollectionControllerView = highlightsCollectionController.view!
                highlightsCollectionControllerView.translatesAutoresizingMaskIntoConstraints = false
                cell3.highlightsColumnStack.addArrangedSubview(highlightsCollectionController.view)
            }
            return cell3
        }
        else if indexPath.section == 1 {
            if cell2.collectionController == nil {
                let collectionController = storyboard?.instantiateViewController(withIdentifier: "nearbyCollection") as! nearbyEventsCollectionViewController
                cell2.collectionController = collectionController
                let collectionControllerView = collectionController.view!
                collectionControllerView.translatesAutoresizingMaskIntoConstraints = false
                cell2.columnStack.addArrangedSubview(collectionController.view)
                let layout = collectionController.collectionViewLayout as! UICollectionViewFlowLayout
                NSLayoutConstraint.activate([
                    collectionControllerView.widthAnchor.constraint(equalTo: cell2.columnStack.widthAnchor),
                    collectionControllerView.heightAnchor.constraint(equalToConstant: layout.itemSize.height * 3),
                    ])
            }
            return cell2
        }
        else {
            if cell4.upcomingTableController == nil {
                let upcomingTableController = storyboard?.instantiateViewController(withIdentifier: "upcomingTable") as! upcomingTableViewController
                cell4.upcomingTableController = upcomingTableController
                let upcomingTableControllerView = upcomingTableController.view!
                upcomingTableControllerView.translatesAutoresizingMaskIntoConstraints = false
                cell4.upcomingColumnStack.addArrangedSubview(upcomingTableController.view)
            }
        }
        return cell4
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        index = indexPath.row
//        performSegue(withIdentifier: "details", sender: nil)
//
//    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
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
//        share.backgroundColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1.0)
//
//
//        return [share]
//    }
    
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
