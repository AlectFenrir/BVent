//
//  bookmarkTableViewCell.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 26/04/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class bookmarkTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookmarkPhoto: UIImageView!
    @IBOutlet weak var bookmarkTitle: UILabel!
    @IBOutlet weak var bookMarkBenefit: UILabel!
    @IBOutlet weak var bookmarkPrice: UILabel!
    @IBOutlet weak var bookmarkTime: UILabel!
    @IBOutlet weak var bookmarkPoster: UILabel!
    @IBOutlet weak var bookmarkImageLoader: UIActivityIndicatorView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bookmarkPhoto.layer.cornerRadius = 5
        bookmarkPhoto.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
