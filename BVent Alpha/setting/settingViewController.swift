//
//  settingViewController.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 26/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit
import Firebase

class settingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let judul = ["Account", "Bookmarks", "More"]
    
    @IBOutlet weak var tabel1: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: judul[indexPath.row], sender: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return judul.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tabel1.dequeueReusableCell(withIdentifier: "setting1", for: indexPath) as! settingTableViewCell
        
        cell.judul.text = judul[indexPath.row]
        
        
        return cell
        
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        try! Auth.auth().signOut()
    }
    
}
