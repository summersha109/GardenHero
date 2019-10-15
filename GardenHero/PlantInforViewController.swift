//
//  PlantInforViewController.swift
//  GardenHero
//
//  Created by 朱莎 on 23/8/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class PlantInforViewController: UIViewController, UIScrollViewDelegate {
    
   
    var plantName : String?
    var descrption : String?
    var sun : String?
    var soil : String?
    var water : String?
    var whenToPlant : String?
    var howToPlant : String?
    var harveTime : String?
    var harvest : String?
    var spacing : String?
    var feeding: String?
    var pests: String?
    var otherCare: String?
    
    
    
   
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    @IBOutlet weak var plantNameLabel: UILabel!
    
    
    
    @IBOutlet weak var plantImage: UIImageView!
    
    
    
   
    @IBOutlet weak var plantDescription: UILabel!
    
    
   
    
    
    @IBOutlet weak var sunLabel: UILabel!
    
    
    @IBOutlet weak var spacingLabel: UILabel!
    
    @IBOutlet weak var waterLabel: UILabel!
    
    
    @IBOutlet weak var feedingLabel: UILabel!
    
    @IBOutlet weak var soilLabel: UILabel!
    
    
    @IBOutlet weak var pestsLabel: UILabel!
    
    
   
    
    @IBOutlet weak var whenToPlantLabel: UILabel!
    
    
    @IBOutlet weak var howToPlantLabel: UILabel!
    
    
    
    
    
    
   
    
    
    
  
    
    
    
    @IBOutlet weak var otherCareLabel: UILabel!
    
    
    @IBOutlet weak var harvestTime: UILabel!
    
   
    @IBOutlet weak var inforSeg: UISegmentedControl!
    
    
    
    
    
    @IBOutlet weak var harvestText: UILabel!
    
    
    
   
    
    
   
    
    
    
    
   
    @IBAction func segements(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            scrollView.setContentOffset(CGPoint( x : 0, y: 0), animated: true)
        case 1:
            scrollView.setContentOffset(CGPoint( x : 375, y: 0), animated: true)
        case 2:
            scrollView.setContentOffset(CGPoint( x : 750, y: 0), animated: true)
        case 3:
            scrollView.setContentOffset(CGPoint( x : 1125, y: 0), animated: true)
        default:
            print("")
        }
    }
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        scrollView.delegate = self
        
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
        if let plantName = plantName, let description = descrption, let sun = sun, let soil = soil, let water = water, let whenToPlant = whenToPlant, let howToPlant = howToPlant, let harveTime = harveTime, let harvest = harvest, let spacing = spacing, let feeding = feeding, let pests = pests, let otherCare = otherCare{
            plantImage.image = UIImage(named: plantName)
            plantNameLabel.text = plantName
            plantDescription.text = description
            sunLabel.text = sun
            soilLabel.text = soil
            waterLabel.text = water
            whenToPlantLabel.text = whenToPlant
            howToPlantLabel.text = howToPlant
            harvestTime.text = harveTime
            harvestText.text = harvest
            spacingLabel.text = spacing
            feedingLabel.text = feeding
            pestsLabel.text = pests
            otherCareLabel.text = otherCare
            
        }
        
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        let index = Int(scrollView.contentOffset.x)
                   if index >= 0, index < 375{
                      inforSeg.selectedSegmentIndex = 0
                  }
                else if index >= 375, index < 750 {
                       inforSeg.selectedSegmentIndex = 1
                }
                    else if index >= 750, index < 1125 {
                    inforSeg.selectedSegmentIndex = 2
                   }
                    else if index >= 1125 {
                        inforSeg.selectedSegmentIndex = 3
                    }
        
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
         scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
    }

}
