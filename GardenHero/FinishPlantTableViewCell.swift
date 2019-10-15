//
//  FinishPlantTableViewCell.swift
//  GardenHero
//
//  Created by 朱莎 on 28/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class FinishPlantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var plantImage: UIImageView!
    
    @IBOutlet weak var finishPlantName: UILabel!
    
    @IBOutlet weak var finishProgressView: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
