//
//  SenderTableViewCell.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 07/11/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageBackground: UIImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var profilePic: RoundedImageView!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
    }
}
