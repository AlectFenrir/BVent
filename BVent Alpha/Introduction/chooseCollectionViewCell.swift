//
//  chooseCollectionViewCell.swift
//  BVent home
//
//  Created by jonathan jordy on 21/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit

class chooseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var catImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 4
        mainView.layer.masksToBounds = true
        
        //        userImage.layer.cornerRadius = 6
        //        userImage.layer.masksToBounds = true
    }
    
}
