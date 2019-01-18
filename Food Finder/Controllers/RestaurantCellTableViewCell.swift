//
//  RestaurantCellTableViewCell.swift
//  Food Finder
//
//  Created by Will Chew on 2018-10-08.
//  Copyright © 2018 Will Chew. All rights reserved.
//

import UIKit

class RestaurantCellTableViewCell: UITableViewCell {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAddress: UILabel!
    @IBOutlet weak var restaurantRatingImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
