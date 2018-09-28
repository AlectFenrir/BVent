//
//  posterCollectionViewCell.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 26/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class posterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var foto: UIImageView!
    
    override func awakeFromNib() {
        foto.layer.cornerRadius = 3
        foto.layer.masksToBounds = true
    }
    
}
