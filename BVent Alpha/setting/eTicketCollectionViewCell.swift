//
//  eTicketCollectionViewCell.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 05/11/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class eTicketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var eTicketImage: WebImageView! {
        didSet {
            eTicketImage.configuration.placeholderImage = UIImage(named: "lightGray")
            eTicketImage.configuration.animationOptions = .transitionCrossDissolve
        }
    }
    @IBOutlet weak var eTicketImageLoader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        eTicketImage.layer.cornerRadius = 8
        eTicketImage.layer.masksToBounds = true
    }
}
