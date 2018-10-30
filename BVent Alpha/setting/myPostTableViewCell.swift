//
//  myPostTableViewCell.swift
//  BVent Alpha
//
//  Created by jonathan jordy on 30/10/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class myPostTableViewCell: UITableViewCell {

    @IBOutlet weak var myPostPhoto: UIImageView!
    @IBOutlet weak var myPostTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myPostPhoto.layer.cornerRadius = 8
        myPostPhoto.layer.masksToBounds = true
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
