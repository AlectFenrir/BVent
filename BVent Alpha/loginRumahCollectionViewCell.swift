//
//  rumahCollectionViewCell.swift
//  BVent home
//
//  Created by jonathan jordy on 25/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit

class loginRumahCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cat: UILabel!
    @IBOutlet weak var foto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foto.layer.cornerRadius = 5
        foto.layer.masksToBounds = true
        
        //        userImage.layer.cornerRadius = 6
        //        userImage.layer.masksToBounds = true
    }
    
}
