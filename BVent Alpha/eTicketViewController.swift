//
//  eTicketViewController.swift
//  BVent Alpha
//
//  Created by ken delatifani on 28/07/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class eTicketViewController: UIViewController {

    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var confirmAtt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ticketView.layer.cornerRadius = 10
        ticketView.clipsToBounds = true
        ticketView.layer.borderWidth = 0.25
        ticketView.layer.borderColor = UIColor.black.cgColor
        
        confirmAtt.layer.cornerRadius = 7
        confirmAtt.clipsToBounds = true
        confirmAtt.layer.borderWidth = 0.25
        confirmAtt.layer.borderColor = UIColor.black.cgColor
        
        
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
