//
//  historyTableViewCell.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 05/12/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class historyTableViewCell: UITableViewCell {

    @IBOutlet weak var historyImage: UIImageView!
    @IBOutlet weak var historyDate: UILabel!
    @IBOutlet weak var historyTitle: UILabel!
    @IBOutlet weak var historyPlace: UILabel!
    @IBOutlet weak var historyImageLoader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        historyImage.layer.cornerRadius = 7
        historyImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
