//
//  upcomingTableViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 26/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class upcomingTableViewController: UITableViewController {
    
    @IBOutlet var upcomingTable: UITableView!
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        startAnimation()
//    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 87
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return upcomingPake.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = upcomingTable.dequeueReusableCell(withIdentifier: "upcomingCell", for: indexPath) as! upcomingTableViewCell
        let url = URL(string: upcomingPake[indexPath.row].imageUrl)

        // Configure the cell...
        cell.eventTitle.text = upcomingPake[indexPath.row].title
        cell.eventDate.text = upcomingPake[indexPath.row].date
        cell.eventLocation.text = upcomingPake[indexPath.row].location
        cell.eventImage.load(url: url!)
        
//        ImageService.getImage(withURL: url!) { (image) in
//            cell.eventImage.image = image
//            self.stopAnimation()
//        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        goToLocation()
    }
    
    func goToLocation() {
        let locationTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail1ViewController") as! detail1ViewController
        locationTableVC.index = index!
        let navigationController = UINavigationController(rootViewController: locationTableVC)
        //self.present(navigationController, animated: true, completion: nil)
        self.show(navigationController, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "upcomingDetails" {
                let destination = segue.destination as! detail1ViewController
                destination.index = index
            }
        }
    }

}

extension upcomingTableViewController {
    func startAnimation() {
        for animateView in getSubViewsForAnimate() {
            animateView.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.withAlphaComponent(0.8).cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.7, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.8)
            gradientLayer.frame = animateView.bounds
            animateView.layer.mask = gradientLayer
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 1.5
            animation.fromValue = -animateView.frame.size.width
            animation.toValue = animateView.frame.size.width
            animation.repeatCount = .infinity
            
            gradientLayer.add(animation, forKey: "")
        }
    }
    
    func stopAnimation() {
        for animateView in getSubViewsForAnimate() {
            animateView.layer.removeAllAnimations()
            animateView.layer.mask = nil
        }
    }
    
    func getSubViewsForAnimate() -> [UIView] {
        var obj: [UIView] = []
        for objView in view.subviewsRecursive() {
            obj.append(objView)
        }
        return obj.filter({ (obj) -> Bool in
            obj.shimmerAnimation
        })
    }
}
