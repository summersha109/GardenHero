//
//  StartPlantTableViewController.swift
//  GardenHero
//
//  Created by 朱莎 on 28/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import RealmSwift

class StartPlantTableViewController: UITableViewController {
    
    var startPlantList: Results<StartPlant>?
    var finishPlantList: Results<FinishPlant>?
    let realm = try! Realm()
     let plantScore = ["Tomato": 7.6,"Potato": 4.3,"Pumpkin": 3.7 ,"Lettuce": 3.2,"Carrot": 7.7,"Onion": 4.7,"Garlic": 5.2,"Kale": 4.5,"Spinach": 3.5,"Sweet Corn": 6.7,"Watermelon": 9.3,"Cabbage": 4.2,"Cucumbers": 2.2,"Broccoli": 3.1,"Summer Squash": 4.3,"Radishes": 7.5,"Asparagus": 2.2,"Beets": 1.8,"Cauliflower": 2.3,"Celery": 1.75,"Cilantro":3.4,"Sweet Potato": 4.7,"Parsnips": 1.9,"Apple": 3.8,"Orange": 9.2,"Banana": 9.7,"Grape": 9.7,"Avocado": 9.6]
    override func viewDidLoad() {
        super.viewDidLoad()

        startPlantList = realm.objects(StartPlant.self)
        finishPlantList = realm.objects(FinishPlant.self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return startPlantList!.count
        } else{
            return finishPlantList!.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let startPlantCell = tableView.dequeueReusableCell(withIdentifier: "startPlantCell", for: indexPath) as? StartPlantTableViewCell else {
                return UITableViewCell()
                
            }
            startPlantCell.plantImage.image = UIImage(named: startPlantList![indexPath.row].plantName)
            startPlantCell.plantName.text = startPlantList![indexPath.row].plantName
             startPlantCell.btn.tag = indexPath.row
             startPlantCell.btn.setTitle("Growing", for: .normal)
            startPlantCell.btn.isUserInteractionEnabled = false
            startPlantCell.btn.alpha=0.4
  
           
            if progressBar(indexPath: indexPath.row) >= 1.0 {
                startPlantCell.btn.setTitle("Harvest", for: .normal)
                startPlantCell.btn.alpha = 1
                startPlantCell.btn.isUserInteractionEnabled = true
                startPlantCell.btn.addTarget(self, action: #selector(harvestBtn), for: .touchUpInside)
            }
            
            startPlantCell.startProgressView.progress = Float(progressBar(indexPath: indexPath.row))
            return startPlantCell
        } else {
            guard let finishPlantCell = tableView.dequeueReusableCell(withIdentifier: "finishPlantCell", for: indexPath) as? FinishPlantTableViewCell else {
                return UITableViewCell()
            }
            finishPlantCell.plantImage.image = UIImage(named: finishPlantList![indexPath.row].plantName)
            finishPlantCell.finishPlantName.text = finishPlantList![indexPath.row].plantName
            finishPlantCell.finishProgressView.progress = 1
            return finishPlantCell
        }
        
 
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Growing"
        } else {
            return "Finished"
        }
       
    }
    
    
    @IBAction func harvestBtn(_ sender: UIButton) {
        let row = sender.tag
        let finishPlantName = startPlantList![row].plantName
        let finishToPlant = FinishPlant()
        finishToPlant.plantName = finishPlantName
        do{
            try realm.write{
                realm.delete(startPlantList![row])
            }
        }catch{
            print(error)
        }
        
        do{
            try self.realm.write{
                self.realm.add(finishToPlant)
            }
            
        }catch{
            print(error)
        }
        
        tableView.reloadData()
        let co2 = Double(plantScore[finishPlantName]!) * 10
        
        let harvestScore = HarvestScore()
        harvestScore.score = Int(plantScore[finishPlantName]!)
        harvestScore.co2 = Int(co2)
        
        do{
            try realm.write{
                realm.add(harvestScore)
            }
            
        }catch{
            print(error)
        }
        
    }
    
    func progressBar(indexPath: Int) -> Double{ // pass future date string
        let harvestDate = startPlantList![indexPath].harvestDate.asDate
        let nowDays = harvestDate.daysSinceNow.day!
        let totalDays = startPlantList![indexPath].harvestDay
        let percent = Double((Double(totalDays) - Double(nowDays)) / Double(totalDays))
        
        return percent
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if indexPath.section == 0{
            do{
                try realm.write{
                    realm.delete(startPlantList![indexPath.row])
                }
            }catch{
                print(error)
            }
            
           tableView.reloadData()
            }
            if indexPath.section == 1{
                do{
                    try realm.write{
                        realm.delete(finishPlantList![indexPath.row])
                    }
                }catch{
                    print(error)
                }
                
                tableView.reloadData()
            }
        }
    }
    
    
    



}



