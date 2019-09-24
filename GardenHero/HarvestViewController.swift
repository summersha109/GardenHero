//
//  HarvestViewController.swift
//  GardenHero
//
//  Created by 朱莎 on 11/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CZPicker
import RealmSwift

class HarvestViewController: UIViewController {
    
    @IBOutlet weak var harvestPlantText: UITextField!
    
    
    @IBOutlet weak var harvestWeightText: UITextField!
    let realm = try! Realm()
    let plant = ["Tomato","Potato","Pumpkin","Lettuce","Carrot","Onion","Garlic","Kale","Spinach","Sweet Corn","Watermelon","Cabbage","Cucumbers","Broccoli","Summer Squash","Radishes","Asparagus","Beets","Cauliflower","Celery","Cilantro","Sweet Potato","Parsnips","Apple","Orange","Banana","Grape","Avocado"]
    let plantScore = ["Tomato": 7.6,"Potato": 4.3,"Pumpkin": 3.7 ,"Lettuce": 3.2,"Carrot": 7.7,"Onion": 4.7,"Garlic": 5.2,"Kale": 4.5,"Spinach": 3.5,"Sweet Corn": 6.7,"Watermelon": 9.3,"Cabbage": 4.2,"Cucumbers": 2.2,"Broccoli": 3.1,"Summer Squash": 4.3,"Radishes": 7.5,"Asparagus": 2.2,"Beets": 1.8,"Cauliflower": 2.3,"Celery": 1.75,"Cilantro":3.4,"Sweet Potato": 4.7,"Parsnips": 1.9,"Apple": 3.8,"Orange": 9.2,"Banana": 9.7,"Grape": 9.7,"Avocado": 9.6]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func selectPlantButton(_ sender: Any) {
        let picker = CZPickerView(headerTitle: "Plants", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = true
        picker?.show()
    }
    
    @IBAction func submitButtion(_ sender: Any) {
    if harvestPlantText.text != "", harvestPlantText.text != ""{
        let plantName = harvestPlantText.text!
        let weight = Double(harvestWeightText.text!)
        let co2 = Double(plantScore[plantName]!) * 10
       
            let harvestScore = HarvestScore()
            harvestScore.score = Int(plantScore[plantName]!)
            harvestScore.co2 = Int(co2)
            
            do{
                try realm.write{
                    realm.add(harvestScore)
                }
                
            }catch{
                print(error)
            }
            
            navigationController?.popViewController(animated: true)
        } else {
            displayMessage(title: "Error", message: "Please input the information")
        }
        
    }
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return plant.count
    }
    
}

extension HarvestViewController: CZPickerViewDelegate, CZPickerViewDataSource{
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        return plant.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return plant[row]
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        harvestPlantText.text = plant[row]
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    
    
}







