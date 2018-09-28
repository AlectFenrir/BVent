//
//  chooseViewController.swift
//  BVent home
//
//  Created by jonathan jordy on 21/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit

class chooseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var done: UIButton!
    
    @IBOutlet weak var chooseCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.4, blue: 0.5568627451, alpha: 1)
        
        chooseCollectionView?.backgroundColor = .clear
        chooseCollectionView?.contentInset = UIEdgeInsets(top: 10 , left: 18, bottom: 10, right: 18)
        
        done.layer.cornerRadius = 7
        done.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chooseCell", for: indexPath) as! chooseCollectionViewCell
        
        cell.catImage.image = UIImage(named: "cat1")
        
        return cell
    }
    
    @IBAction func skip(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.setValue(true, forKey: "skip")
        defaults.synchronize()
        
        
        let nextView: UITabBarController = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        appdelegate.window!.rootViewController = nextView
    }
    
    @IBAction func doneChooseInterest(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.setValue(true, forKey: "doneChooseInterest")
        defaults.synchronize()
        
        
        let nextView: UITabBarController = self.storyboard?.instantiateViewController(withIdentifier: "main") as! UITabBarController
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        appdelegate.window!.rootViewController = nextView
    }
    
    
}
