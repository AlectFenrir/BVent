//
//  highlightsCollectionViewCell.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 14/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class highlightsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var highlightsImage: WebImageView! {
        didSet {
            highlightsImage.configuration.placeholderImage = UIImage(named: "lightGray")
            highlightsImage.configuration.animationOptions = .transitionCrossDissolve
        }
    }
    //var highlightsCollectionController: highlightsCollectionViewController?
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        highlightsImage.clipsToBounds = true
    }
}
