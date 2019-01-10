//
//  highlightsCollectionViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 14/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase
import Cards
import Shimmer

class highlightsCollectionViewController: UICollectionViewController {
    
    @IBOutlet var highlightsCollectionView: UICollectionView!
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var itemSize = CGSize(width: 0, height: 0)
    var index: Int?
    
    @objc func fetchHighlights() {
        automaticallyAdjustsScrollViewInsets = false
        self.highlightsCollectionView.dataSource = self
        self.highlightsCollectionView.delegate = self
        if let layout = self.highlightsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = self.sectionInsets
            layout.scrollDirection = .horizontal
        }
        self.highlightsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.highlightsCollectionView.isPagingEnabled = false
        self.view.layoutIfNeeded()
        
        let width = self.highlightsCollectionView.bounds.size.width
        let height = self.highlightsCollectionView.bounds.size.height // width * (9/16)
        self.itemSize = CGSize(width: width, height: height)
        print("itemSize: \(self.itemSize)")
        //self.collectionViewHeight.constant = height
        self.view.layoutIfNeeded()
        self.highlightsCollectionView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        fetchHighlights()
        startTimer()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        startAnimation()
//    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "highlightsDetails" {
                let destination = segue.destination as! highlightsDetailsViewController
                destination.index = index
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print("highlightsItem.count: \(highlightsPake.count)")
        return highlightsPake.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = highlightsCollectionView.dequeueReusableCell(withReuseIdentifier: "highlightsCell", for: indexPath) as! highlightsCollectionViewCell
        let url = URL(string: highlightsPake[indexPath.row].imageUrl)
//        let card = cell.viewWithTag(1000) as! CardArticle
//        let cardContent = storyboard!.instantiateViewController(withIdentifier: "detail1ViewController")
        
//        var shimmeringView = FBShimmeringView(frame: cell.highlightsImage.frame)
//        shimmeringView.layer.cornerRadius = 8
//        shimmeringView.shimmeringOpacity = 1
//        var loadingLabel = UIImageView(frame: cell.highlightsImage.frame)
//        loadingLabel.image = UIImage(imageLiteralResourceName: "lightGray")
//        shimmeringView.contentView = loadingLabel
//        view.addSubview(shimmeringView)
        
//        var loadingLabel = UIImageView(frame: shimmeringView.frame)
//        //loadingLabel.textAlignment = .center
//        loadingLabel.image = UIImage(imageLiteralResourceName: "lightGray")
//        shimmeringView.contentView = loadingLabel
        
        // Start shimmering.
        //shimmeringView.isShimmering = true
        
        cell.highlightsImage.load(url: url!)
        
//        ImageService.getImage(withURL: url!) { (image) in
//            cell.highlightsImage.image = image
//            self.stopAnimation()
////            shimmeringView.isShimmering = false
////            shimmeringView.isHidden = true
//        }
        
//        card.shouldPresent(cardContent, from: self, fullscreen: true)
    
        // Configure the cell
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        index = indexPath.row
        goToLocation()
    }
    
    //MARK: flowlayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = itemSize.width
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.5
        if velocity.x < 0 {
            factor = -factor
            print("swipe right")
        } else {
            print("swipe left")
        }

        var index = Int( round((scrollView.contentOffset.x/pageWidth)+factor) )
        if index < 0 {
            index = 0
        }
        if index > highlightsPake.count-1 {
            index = highlightsPake.count-1
        }
        let indexPath = IndexPath(row: index, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    @objc func scrollAutomatically(_ timer: Timer) {
        
        if let coll  = highlightsCollectionView {
            for cell in coll.visibleCells {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                if ((indexPath?.row)!  < highlightsPake.count - 1){
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                }
                else{
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                }
                
            }
        }
        
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)
    }
    
    func goToLocation() {
        let locationTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail1ViewController") as! detail1ViewController
        locationTableVC.index = index!
        let navigationController = UINavigationController(rootViewController: locationTableVC)
        //self.present(navigationController, animated: true, completion: nil)
        self.show(navigationController, sender: nil)
    }

}

extension highlightsCollectionViewController {
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
