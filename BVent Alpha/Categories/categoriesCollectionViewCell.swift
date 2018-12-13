//
//  categoriesCollectionViewCell.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 04/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class categoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var cat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foto.layer.cornerRadius = 5
        foto.layer.masksToBounds = true
        
        //        userImage.layer.cornerRadius = 6
        //        userImage.layer.masksToBounds = true
    }
}
