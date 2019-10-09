//
//  rumahCollectionViewCell.swift
//  BVent home
//
//  Created by jonathan jordy on 25/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit

class rumahCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cat: UILabel!
    @IBOutlet weak var foto: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foto.layer.cornerRadius = 7
        foto.layer.masksToBounds = true
    }
}
