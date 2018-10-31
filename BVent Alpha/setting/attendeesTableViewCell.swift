//
//  attendeesTableViewCell.swift
//  BVent Alpha
//
//  Created by jonathan jordy on 31/10/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class attendeesTableViewCell: UITableViewCell {

    @IBOutlet weak var attendeesName: UILabel!
    @IBOutlet weak var attendeesEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
