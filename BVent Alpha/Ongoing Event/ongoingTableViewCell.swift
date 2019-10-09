//
//  ongoingTableViewCell.swift
//  BVent Pre-Alpha
//
//  Created by Rayhan Martiza Faluda on 03/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class ongoingTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ongoingEventImage: WebImageView! {
        didSet {
            ongoingEventImage.configuration.placeholderImage = UIImage(named: "lightGray")
            ongoingEventImage.configuration.animationOptions = .transitionCrossDissolve
        }
    }
    @IBOutlet weak var ongoingEventTitle: UILabel!
    @IBOutlet weak var ongoingEventPrice: UILabel!
    @IBOutlet weak var ongoingEventBenefit: UILabel!
    @IBOutlet weak var ongoingEventCDown: UILabel!
    @IBOutlet weak var ongoingEventPoster: UILabel!
    @IBOutlet weak var done: UILabel!
    @IBOutlet weak var ongoingImageLoader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ongoingEventImage.layer.cornerRadius = 5
        ongoingEventImage.layer.masksToBounds = true
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
