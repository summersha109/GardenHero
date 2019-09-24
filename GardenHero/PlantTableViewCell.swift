//
//  PlantTableViewCell.swift
//  GardenHero
//
//  Created by 朱莎 on 23/8/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var plantLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    @IBOutlet weak var foodMile: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
