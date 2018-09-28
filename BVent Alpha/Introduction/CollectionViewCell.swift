//
//  CollectionViewCell.swift
//  BVent home
//
//  Created by jonathan jordy on 15/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        //        userImage.layer.cornerRadius = 6
        //        userImage.layer.masksToBounds = true
    }
    
}

