//
//  eTicketCollectionViewCell.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 05/11/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class eTicketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eTicketImage: UIImageView!
    @IBOutlet weak var eTicketImageLoader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eTicketImage.layer.cornerRadius = 5
        eTicketImage.layer.masksToBounds = true
    }
}
