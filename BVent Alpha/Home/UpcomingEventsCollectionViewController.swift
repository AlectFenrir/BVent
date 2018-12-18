//
//  UpcomingEventsCollectionViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 08/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class UpcomingEventsCollectionViewController: UICollectionViewController {
    
    @IBOutlet var UpcomingCollectionView: UICollectionView!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpcomingCollectionView?.dataSource = self
        UpcomingCollectionView?.delegate = self
//        collectionView!.decelerationRate = .fast
        UpcomingCollectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        UpcomingCollectionView?.reloadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        UpcomingCollection.reloadData()
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
        layout.itemSize.width = min(UpcomingCollectionView!.bounds.size.width - 25, 500)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingPake.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UpcomingCollectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCell", for: indexPath) as! UpcomingEventsCollectionViewCell
        cell.eventTitle.text = upcomingPake[indexPath.row].title
        cell.eventDate.text = upcomingPake[indexPath.row].date
        cell.eventLocation.text = upcomingPake[indexPath.row].location
        let url = URL(string: upcomingPake[indexPath.row].imageUrl)
        ImageService.getImage(withURL: url!) { (image) in
            cell.eventImage.image = image
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "upcomingDetails", sender: nil)
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier{
//            if identifier == "upcomingDetails"{
//                let destination = segue.destination as! detail1ViewController
//                destination.index = index
//            }
//        }
//    }

}
