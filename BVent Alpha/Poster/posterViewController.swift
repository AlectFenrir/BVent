//
//  posterViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 26/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class posterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var follow: UIButton!
    var dataaa: [kumpulanData] = kumpulanData.fetch()
    
    var pakeee: [kumpulanData] = []
    
    var index: Int?
    
    @IBOutlet weak var collection1: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        follow.layer.cornerRadius = 7
        follow.layer.masksToBounds = true
        
        pakeee = dataaa
        
        collection1?.backgroundColor = .clear
        collection1?.contentInset = UIEdgeInsets(top: 10, left: 3, bottom: 10, right: 3)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection1.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath) as! posterCollectionViewCell
        
        //cell.foto.image = pakeee[indexPath.row].image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        index = indexPath.row
        performSegue(withIdentifier: "details", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "details"{
                let destination = segue.destination as! detail4ViewController
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
