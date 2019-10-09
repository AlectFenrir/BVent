//
//  categoriesViewController.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 04/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class categoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let main = ["All", "Design", "Economy", "Engineering", "Jobs", "Lifestyle", "Social", "Technologies"]
    
    let cat = ["icons8-categorize-90", "cat4", "cat2", "cat7", "cat6", "cat5", "cat3", "cat1"]
    
    var lempar: String? = ""
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoriesCell", for: indexPath) as! categoriesCollectionViewCell
        
        cell.foto.image = UIImage(named: cat[indexPath.row])
        cell.cat.text = main[indexPath.row]
        //cell.cat.text = main[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (main[indexPath.row] != "All"){
            lempar = main[indexPath.row]
        }
        else{
            lempar = "All"
        }
        
        performSegue(withIdentifier: "categories", sender: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if identifier == "categories"{
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
