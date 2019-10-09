//
//  catTableViewCell.swift
//  BVent home
//
//  Created by jonathan jordy on 18/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit

class catTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var foto: WebImageView! {
        didSet {
            foto.configuration.placeholderImage = UIImage(named: "lightGray")
            foto.configuration.animationOptions = .transitionCrossDissolve
        }
    }
    @IBOutlet weak var judul: UILabel!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var poster: UILabel!
    @IBOutlet weak var categoryImageLoader: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        foto.layer.cornerRadius = 5
        foto.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    open func configure(poster: String)
    {
        self.poster.text = poster
    }
    
}
