//
//  PlantListViewController.swift
//  GardenHero
//
//  Created by 朱莎 on 23/8/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftSocket
import SwiftyJSON
import CZPicker

class PlantListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var plantTableView: UITableView!
    
    //@IBOutlet weak var segmentedConrol: UISegmentedControl!
    
    
    @IBOutlet weak var selectBtn: UIButton!
    
    var plants : [Plant] = []
    
    var filterPlants: [Plant] = []
    var allPlant: [Plant] = []
    let client = TCPClient(address: "3.104.105.21", port: 9999)
    let months = ["January","February","March","April","May","June","July","August","Septempber","October","November","December"]
    var month: String?
     let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
         allPlant.removeAll()
         plants.removeAll()
        connectServer(request: "SEASONAL")
        filterPlants = plants
        
       
        selectBtn.isHidden = true
        self.searchBarSetup()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        allPlant.removeAll()
        connectServer(request: "ALL")
       
        //filterPlants = allPlant

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
   
    
    func searchBarSetup(){
        let searchBar = UISearchBar(frame: CGRect(x:0,y:107, width:(UIScreen.main.bounds.width),height: 70))
        searchBar.delegate = self
        searchBar.placeholder = "Search Plants"
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Seasonal Plants", "All Plants"]
        searchBar.selectedScopeButtonIndex = 1
        searchBar.selectedScopeButtonIndex = 0
        searchBar.delegate = self
        plantTableView.tableHeaderView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()

    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchBar.resignFirstResponder()
        if searchBar.selectedScopeButtonIndex == 0{
            selectBtn.isHidden = true
            filterPlants = plants
            plantTableView.reloadData()
        } else if searchBar.selectedScopeButtonIndex == 1{
            allPlant.removeAll()
            connectServer(request: "ALL")
            selectBtn.isHidden = false
            filterPlants = allPlant
            plantTableView.reloadData()
        }
    }
    
   
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            searchBar.resignFirstResponder()
            if searchBar.selectedScopeButtonIndex == 0{
                filterPlants = plants
                plantTableView.reloadData()
            } else if searchBar.selectedScopeButtonIndex == 1{
                selectBtn.isHidden = false
                filterPlants = allPlant
                plantTableView.reloadData()
            }
        }
        else{
            filterPlants = allPlant.filter({(plant) -> Bool in
                return plant.name.lowercased().contains(searchText.lowercased())
            })
            plantTableView.reloadData()
        }
    }

    
//    func filterTableView(ind:Int, text: String){
//        switch ind {
//        case 0:
//            filterPlants = plants.filter({(plant) -> Bool in
//                return plant.name.lowercased().contains(text.lowercased())
//            })
//            plantTableView.reloadData()
//        case 1:
//            filterPlants = allPlant.filter({(plant) -> Bool in
//                return plant.name.lowercased().contains(text.lowercased())
//            })
//            plantTableView.reloadData()
//        default:
//            break
//        }
//    }
    
    // Press segenment button, what will present
//    @IBAction func segmentedChange(_ sender: Any) {
//        plantTableView.reloadData()
//    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0{
            filterPlants = allPlant.filter({(plant: Plant) -> Bool in
                return plant.name.lowercased().contains(searchText.lowercased())})
        
        }
        else{
            filterPlants = allPlant
        }
        plantTableView.reloadData()
        
    }
    
    func searchBarIsEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPlants.count
//        switch  segmentedConrol.selectedSegmentIndex {
//        case 0:
//            selectBtn.isHidden = true
//
//            return plants.count
//        case 1:
//            selectBtn.isHidden = false
//            searchController.searchResultsUpdater = self
//            searchController.obscuresBackgroundDuringPresentation = false
//            searchController.searchBar.placeholder = "Search Plants"
//
//
//            navigationItem.searchController = searchController
//            definesPresentationContext = true
//            return allPlant.count
//        default:
//            break
//        }
//        return 0
    }
    
    // Multiple item picker
    @IBAction func selectMonth(_ sender: Any) {
        let picker = CZPickerView(headerTitle: "Months", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker?.delegate = self
        picker?.dataSource = self
        picker?.needFooterView = false
        picker?.allowMultipleSelection = true
        picker?.show()
    }
    // Multiple items picker
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return months.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fruitCell", for: indexPath) as? PlantTableViewCell else {
            return UITableViewCell()
            
        }
        //if segmentedConrol.selectedSegmentIndex == 0 {
            cell.plantImage.image = UIImage(named:filterPlants[indexPath.row].name)
            cell.plantLabel.text = filterPlants[indexPath.row].name
            cell.foodMile.text = "Food Mile Score: \(filterPlants[indexPath.row].foodMile)"
//        } else if segmentedConrol.selectedSegmentIndex == 1 {
//            cell.plantImage.image = UIImage(named:allPlant[indexPath.row].name)
//            cell.plantLabel.text = allPlant[indexPath.row].name
//            cell.foodMile.text = "Food Mile Score: \(allPlant[indexPath.row].foodMile)"
//        }
        
        
        
        return cell
        
    }
    
    
    
    func connectServer(request: String){
        switch client.connect(timeout: 10) {
        case .success:
            print("success")
            switch client.send(string: request ) {
            case .success:
                var response: String = ""
                while true{
                    let data = client.read(1024,timeout: 10)
                    
                    if data != nil {
                        
                        response = response + String(bytes: data!, encoding: .utf8)!
                        
                    } else {
                        break
                    }
                    
                }
                
                if response != nil {
                    if let data = response.data(using: .utf8) {
                        if let json = try? JSON(data: data) {
                            var i = 0
                            for (index,subJson):(String, JSON) in json {
                                createPlantList(jsonArrary: json, indext: i, request: request)
                                i+=1
                            }
                        }
                        
                    }
                    
                }
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        
            
       
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PlantInforViewController{
            
//            if !searchController.isActive, segmentedConrol.selectedSegmentIndex == 0{
//                let indexPath = self.plantTableView.indexPathForSelectedRow
//                controller.plantName = plants[indexPath!.row].name
//                controller.descrption = plants[indexPath!.row].description
//                controller.sun = plants[indexPath!.row].optimalSun
//                controller.soil = plants[indexPath!.row].optimalSoil
//                controller.water = plants[indexPath!.row].watring
//                controller.whenToPlant = plants[indexPath!.row].whenToPlant
//                controller.howToPlant = "\(plants[indexPath!.row].growingFromSeed) \(plants[indexPath!.row].transPlanting) \(plants[indexPath!.row].spacing)"
//                controller.harveTime = plants[indexPath!.row].harvestTime
//                controller.harvest = plants[indexPath!.row].harvesting
//                controller.spacing = plants[indexPath!.row].spacing
//                controller.feeding = plants[indexPath!.row].feeding
//                controller.pests = plants[indexPath!.row].diseases
//                controller.otherCare = plants[indexPath!.row].otherCare
//            } else if !searchController.isActive, segmentedConrol.selectedSegmentIndex == 1{
//                let indexPath = self.plantTableView.indexPathForSelectedRow
//                controller.plantName = allPlant[indexPath!.row].name
//                controller.descrption = allPlant[indexPath!.row].description
//                controller.sun = allPlant[indexPath!.row].optimalSun
//                controller.soil = allPlant[indexPath!.row].optimalSoil
//                controller.water = allPlant[indexPath!.row].watring
//                controller.whenToPlant = allPlant[indexPath!.row].whenToPlant
//                controller.howToPlant = "\(allPlant[indexPath!.row].growingFromSeed) \(allPlant[indexPath!.row].transPlanting) \(allPlant[indexPath!.row].spacing)"
//                controller.harveTime = allPlant[indexPath!.row].harvestTime
//                controller.harvest = allPlant[indexPath!.row].harvesting
//                controller.spacing = allPlant[indexPath!.row].spacing
//                controller.feeding = allPlant[indexPath!.row].feeding
//                controller.pests = allPlant[indexPath!.row].diseases
//                controller.otherCare = allPlant[indexPath!.row].otherCare
//            }
//            else  {
            let indexPath = self.plantTableView.indexPathForSelectedRow
        controller.plantName = filterPlants[indexPath!.row].name
        controller.descrption = filterPlants[indexPath!.row].description
        controller.sun = filterPlants[indexPath!.row].optimalSun
        controller.soil = filterPlants[indexPath!.row].optimalSoil
        controller.water = filterPlants[indexPath!.row].watring
        controller.whenToPlant = filterPlants[indexPath!.row].whenToPlant
        controller.howToPlant = "\(filterPlants[indexPath!.row].growingFromSeed) \(filterPlants[indexPath!.row].transPlanting) \(filterPlants[indexPath!.row].spacing)"
        controller.harveTime = filterPlants[indexPath!.row].harvestTime
        controller.harvest = filterPlants[indexPath!.row].harvesting
        controller.spacing = filterPlants[indexPath!.row].spacing
        controller.feeding = filterPlants[indexPath!.row].feeding
        controller.pests = filterPlants[indexPath!.row].diseases
        controller.otherCare = filterPlants[indexPath!.row].otherCare
            
        }
        
    }
    
    func testAllPlant(){
        allPlant.append(Plant(
            name: "Apple" ,
            description: "apple",
            optimalSun: "apple",
            optimalSoil: "apple",
            plantingConsiderations:"apple" ,
            whenToPlant: "apple",
            growingFromSeed:"apple" ,
            transPlanting:"apple" ,
            spacing:"apple" ,
            watring:"apple" ,
            feeding:"apple" ,
            
            harvestTime:"apple" ,
            harvesting:"apple" ,
            otherCare:"apple" ,
            diseases: "apple",
            peasts:"apple" ,
            foodMile:"apple" ))
        allPlant.append(Plant(
            name: "Banana" ,
            description: "apple",
            optimalSun: "apple",
            optimalSoil: "apple",
            plantingConsiderations:"apple" ,
            whenToPlant: "apple",
            growingFromSeed:"apple" ,
            transPlanting:"apple" ,
            spacing:"apple" ,
            watring:"apple" ,
            feeding:"apple" ,
            
            harvestTime:"apple" ,
            harvesting:"apple" ,
            otherCare:"apple" ,
            diseases: "apple",
            peasts:"apple" ,
            foodMile:"apple" ))
        
    }
    
    
    func createPlantList(jsonArrary: JSON, indext: Int, request: String){
        if request == "SEASONAL"{
            plants.append(Plant(
                name: jsonArrary[indext]["name"].stringValue,
                description : jsonArrary[indext]["description"].stringValue,
                optimalSun: jsonArrary[indext]["optimalSun"].stringValue,
                optimalSoil: jsonArrary[indext]["optimalSoil"].stringValue,
                plantingConsiderations: jsonArrary[indext]["plantingConsiderations"].stringValue,
                whenToPlant: jsonArrary[indext]["whenToPlant"].stringValue,
                growingFromSeed: jsonArrary[indext]["growingFromSeed"].stringValue,
                transPlanting: jsonArrary[indext]["transPlanting"].stringValue,
                spacing: jsonArrary[indext]["spacing"].stringValue,
                watring: jsonArrary[indext]["watering"].stringValue,
                feeding: jsonArrary[indext]["feeding"].stringValue,
                
                harvestTime: jsonArrary[indext]["harvestTime"].stringValue,
                harvesting: jsonArrary[indext]["harvesting"].stringValue,
                otherCare: jsonArrary[indext]["otherCare"].stringValue,
                diseases: jsonArrary[indext]["diseases"].stringValue,
                peasts: jsonArrary[indext]["peasts"].stringValue,
                foodMile: jsonArrary[indext]["foodMile"].stringValue))
        } else {
            
            allPlant.append(Plant(
                name: jsonArrary[indext]["name"].stringValue,
                description : jsonArrary[indext]["description"].stringValue,
                optimalSun: jsonArrary[indext]["optimalSun"].stringValue,
                optimalSoil: jsonArrary[indext]["optimalSoil"].stringValue,
                plantingConsiderations: jsonArrary[indext]["plantingConsiderations"].stringValue,
                whenToPlant: jsonArrary[indext]["whenToPlant"].stringValue,
                growingFromSeed: jsonArrary[indext]["growingFromSeed"].stringValue,
                transPlanting: jsonArrary[indext]["transPlanting"].stringValue,
                spacing: jsonArrary[indext]["spacing"].stringValue,
                watring: jsonArrary[indext]["watering"].stringValue,
                feeding: jsonArrary[indext]["feeding"].stringValue,
                
                harvestTime: jsonArrary[indext]["harvestTime"].stringValue,
                harvesting: jsonArrary[indext]["harvesting"].stringValue,
                otherCare: jsonArrary[indext]["otherCare"].stringValue,
                diseases: jsonArrary[indext]["diseases"].stringValue,
                peasts: jsonArrary[indext]["peasts"].stringValue,
                foodMile: jsonArrary[indext]["foodMile"].stringValue))
            
        }
       
        
       
    }
    
    
    
   
}

// Multiple items picker
extension PlantListViewController: CZPickerViewDelegate, CZPickerViewDataSource{
   

    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        return months.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return months[row]
    }
    
   
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [Any]!) {
        month = "All year"
        for row in rows{
            
            if let row = row as? Int{
                //print(months[row] + ",")
                month = month! + "," + months[row]
            }
        }
        
        allPlant.removeAll()
        connectServer(request: month!)
         filterPlants = allPlant
        plantTableView.reloadData()
        
    }
}

