//
//  HarvestScore.swift
//  GardenHero
//
//  Created by 朱莎 on 11/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import Foundation
import RealmSwift

class HarvestScore: Object {
    @objc dynamic var score = 0
    @objc dynamic var co2 = 0
}

class StartPlant: Object {
    @objc dynamic var plantName: String = ""
    @objc dynamic var startDate: String = ""
    @objc dynamic var harvestDay: Int = 0
    @objc dynamic var harvestDate: String = ""
}

class FinishPlant: Object {
    @objc dynamic var plantName: String = ""
}


