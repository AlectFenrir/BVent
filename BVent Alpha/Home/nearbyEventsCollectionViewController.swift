//
//  UpcomingEventsCollectionViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 08/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class nearbyEventsCollectionViewController: UICollectionViewController {
    
    @IBOutlet var nearbyCollectionView: UICollectionView!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nearbyCollectionView?.dataSource = self
        nearbyCollectionView?.delegate = self
//        collectionView!.decelerationRate = .fast
        nearbyCollectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        nearbyCollectionView?.reloadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        startAnimation()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "upcomingDetails" {
                let destination = segue.destination as! detail1ViewController
                destination.index = index
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize.width = min(nearbyCollectionView!.bounds.size.width - 30, 600)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyPake.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = nearbyCollectionView.dequeueReusableCell(withReuseIdentifier: "nearbyCell", for: indexPath) as! nearbyEventsCollectionViewCell
        cell.eventTitle.text = nearbyPake[indexPath.row].title
        cell.eventDate.text = nearbyPake[indexPath.row].date
        cell.eventLocation.text = nearbyPake[indexPath.row].location
        
        let url = URL(string: nearbyPake[indexPath.row].imageUrl)
        cell.eventImage.load(url: url!)
        
//        ImageService.getImage(withURL: url!) { (image) in
//            cell.eventImage.image = image
//            self.stopAnimation()
//        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        goToLocation()
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let bounds = scrollView.bounds
        let xTarget = targetContentOffset.pointee.x
        
        // This is the max contentOffset.x to allow. With this as contentOffset.x, the right edge of the last column of cells is at the right edge of the collection view's frame.
        let xMax = scrollView.contentSize.width - scrollView.bounds.width
        
        if abs(velocity.x) <= snapToMostVisibleColumnVelocityThreshold {
            let xCenter = scrollView.bounds.midX
            let poses = layout.layoutAttributesForElements(in: bounds) ?? []
            // Find the column whose center is closest to the collection view's visible rect's center.
            let x = poses.min(by: { abs($0.center.x - xCenter) < abs($1.center.x - xCenter) })?.frame.origin.x ?? 0
            targetContentOffset.pointee.x = x
        } else if velocity.x > 0 {
            let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
            // Find the leftmost column beyond the current position.
            let xCurrent = scrollView.contentOffset.x
            let x = poses.filter({ $0.frame.origin.x > xCurrent}).min(by: { $0.center.x < $1.center.x })?.frame.origin.x ?? xMax
            targetContentOffset.pointee.x = min(x, xMax)
        } else {
            let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget - bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
            // Find the rightmost column.
            let x = poses.max(by: { $0.center.x < $1.center.x })?.frame.origin.x ?? 0
            targetContentOffset.pointee.x = max(x, 0)
        }
    }
    
    // Velocity is measured in points per millisecond.
    private var snapToMostVisibleColumnVelocityThreshold: CGFloat { return 0.3 }
    
    func goToLocation() {
        let locationTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail1ViewController") as! detail1ViewController
        locationTableVC.index = index!
        let navigationController = UINavigationController(rootViewController: locationTableVC)
        //self.present(navigationController, animated: true, completion: nil)
        self.show(navigationController, sender: nil)
    }

}

extension nearbyEventsCollectionViewController {
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
