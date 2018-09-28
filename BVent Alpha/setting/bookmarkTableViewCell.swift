//
//  bookmarkTableViewCell.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 26/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class bookmarkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foot: UIImageView!
    @IBOutlet weak var judul: UILabel!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cDown: UILabel!
    @IBOutlet weak var poster: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        foot.layer.cornerRadius = 5
        foot.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
