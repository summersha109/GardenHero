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
import RealmSwift

class PlantListViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var plantTableView: UITableView!
    
    //@IBOutlet weak var segmentedConrol: UISegmentedControl!
    
    
    @IBOutlet weak var selectBtn: UIButton!
    
    let realm = try! Realm()
   
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
    
    
    
    @IBAction func startToPlantBtn(_ sender: UIButton) {
       
        let row = sender.tag
        let startPlantName = filterPlants[row].name
        let harvestDate = getHarvest(request: startPlantName)
        let futureDay = harvestDate.asDate
        let date = Date.getCurrentDate()
        let harvest = futureDay.daysSinceNow.day!
       
       
        let alert = UIAlertController(title: "Notice", message: "Are you sure to start to plant \(startPlantName) at \(date)",         preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default,handler: nil))
        
        alert.addAction(UIAlertAction(title: "Confirm",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                   self.displayMessage(title: "Success", message: "Your plant has been added in the list")
                                        let startToPlant = StartPlant()
                                       startToPlant.plantName = startPlantName
                                        startToPlant.startDate = date
                                        startToPlant.harvestDay = harvest
                                        startToPlant.harvestDate = harvestDate
                                        
                                        do{
                                            try self.realm.write{
                                                self.realm.add(startToPlant)
                                            }
                                           
                                        }catch{
                                            print(error)
                                        }
       
        }))
       
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
   
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "fruitCell", for: indexPath) as? PlantTableViewCell else {
            return UITableViewCell()
            
        }
            cell.plantImage.image = UIImage(named:filterPlants[indexPath.row].name)
            cell.plantLabel.text = filterPlants[indexPath.row].name
            cell.foodMile.text = "Food Mile Score: \(filterPlants[indexPath.row].foodMile)"
       
           
                cell.startPlantBtn.tag = indexPath.row
                cell.startPlantBtn.addTarget(self, action: #selector(startToPlantBtn), for: .touchUpInside)
        
        if filterPlants.count == 28 {
             cell.startPlantBtn.isHidden = true
        } else {
            cell.startPlantBtn.isHidden = false
        }
        
        
        
        

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
    
    func getHarvest(request: String) -> String {
        var result: String?
        switch client.connect(timeout: 10) {
        case .success:
            print("success")
            switch client.send(string: request ) {
            case .success:
                var response: String = ""
                while true{
                    let data = self.client.read(1024,timeout: 10)
                    if data != nil {
                        
                        response = response + String(bytes: data!, encoding: .utf8)!
                        result = response
                        
                    } else {
                        
                        break
                    }
                }
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        
        return result!
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PlantInforViewController{
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

extension Date {
    
    static func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: Date())
        
    }
}

