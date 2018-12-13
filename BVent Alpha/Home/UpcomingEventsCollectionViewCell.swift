//
//  UpcomingEventsCollectionViewCell.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 08/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class UpcomingEventsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        eventImage.clipsToBounds = true
        eventImage.layer.cornerRadius = 8
        
        //        buyButton.clipsToBounds = true
        //        buyButton.layer.cornerRadius = 8
    }
}
