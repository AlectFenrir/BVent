//
//  rumahTableViewCell.swift
//  BVent home
//
//  Created by jonathan jordy on 25/04/18.
//  Copyright © 2018 jonathan jordy. All rights reserved.
//

import UIKit

class loginRumahTableViewCell: UITableViewCell {
    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var judul: UILabel!
    @IBOutlet weak var benefit: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cDown: UILabel!
    @IBOutlet weak var poster: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        foto.layer.cornerRadius = 3
        foto.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func set(post: Post)
    {
        ImageService.getImage(withURL: post.eventImageURL) { image in
            self.foto.image = image
        }
        
        poster.text = post.author.fullname
        judul.text = post.eventTitle
        price.text = post.eventPrice
    }
    
}
