//
//  Market.swift
//  GardenHero
//
//  Created by 朱莎 on 12/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import Foundation
import MapKit

class Market: NSObject,MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double) {
        self.title = newTitle
        self.subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
    }
    
    
}
