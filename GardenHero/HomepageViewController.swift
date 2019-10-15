//
//  ViewController.swift
//  GardenHero
//
//  Created by 朱莎 on 20/8/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import RealmSwift
import SwiftSocket
import UserNotifications



class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UNUserNotificationCenterDelegate{
    
    
    @IBOutlet weak var tempreature: UILabel!
    @IBOutlet weak var rainFall: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
   
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    @IBOutlet weak var fruitImage: UIImageView!
    
    @IBOutlet weak var co2Label: UILabel!
    
    @IBOutlet weak var fruitNameLabel: UILabel!
    
    @IBOutlet weak var startlabel: UILabel!
    
    
    @IBOutlet weak var harvestLabel: UILabel!
    
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    
    @IBOutlet weak var totalPlants: UILabel!
    
    let weatherAppid = "225f741930286a60f40c542da28f069a"
    let locationManager = CLLocationManager()
    let weather = Weather()
    let realm = try! Realm()
    var maxTemp = 0
    
   
    let images = ["1","2","3","4","5","6","1"]
    
    var imageIndex = 0
    var harvestScores: Results<HarvestScore>?
    var startPlants: Results<StartPlant>?
    
    let client = TCPClient(address: "3.104.105.21", port: 9999)
    //1.1 Load view
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self // viewcontroller is loction manager delegate
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
        
        
        
        let center = UNUserNotificationCenter.current()
        
        let options: UNAuthorizationOptions = [.sound, .alert]
        
        center.requestAuthorization(options: options) {(granted, error) in
            if error != nil{}
        } // Get user authrize for notifiction.
        
        center.delegate = self
                locationManager.requestWhenInUseAuthorization() //Ask user authorizete loction
                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // The accurancy is 100m
                locationManager.requestLocation() // Only request user once
        
        
        
    }
    
    //1.1 Load view
    override func viewWillAppear(_ animated: Bool) {
        harvestScores = realm.objects(HarvestScore.self)
        startPlants = realm.objects(StartPlant.self)
        totalPlants.text = "\(startPlants!.count)"
        if startPlants!.count == 0{
            fruitImage.isHidden = true
            fruitNameLabel.isHidden = true
            startlabel.isHidden = true
            harvestLabel.isHidden = true
            progressView.isHidden = true
        } else {
            
            progressBar()
        }
        createScore()
    }
    
    
    
  
    
    //1.1 Load view
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
   
    
    //1.2 Ask user's location method.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude // Get latitude
        let lon = locations[0].coordinate.longitude // Get longitude
        print(lat,lon)
        let paras = ["lat":"\(lat)","lon":"\(lon)","appid":weatherAppid]
        getWeather(paras: paras)
       
    }
    
    // 1.2 We must add didFailWithErro function
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    //1.3.1 Request weather api and get data
    func getWeather(paras:[String:String]){
        
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast", parameters: paras).responseJSON { response in
            
            if let json = response.result.value {
                let weather = JSON(json)
                
                self.createWeather(weatherJSON : weather)
                self.updateUI()
            }
        }
    }
    
    //1.3.2 Store the api data to Weather object
    func createWeather(weatherJSON:JSON){
      weather.description = weatherJSON["list"][1]["weather"][0]["description"].stringValue
       weather.humidity = weatherJSON["list"][1]["main"]["humidity"].stringValue
        weather.max_temp = Int(round(weatherJSON["list"][1]["main"]["temp_max"].doubleValue) - 273.15)
    
        weather.min_temp = Int(round(weatherJSON["list"][1]["main"]["temp_min"].doubleValue) - 273.15)
        weather.rainfall = weatherJSON["list"][1]["rain"]["3h"].stringValue
        maxTemp = weather.max_temp
       
    }
    
    //1.3.2 Update weather UI view.
    func updateUI(){
        tempreature.text = "\(weather.min_temp) " + "-" + "\(weather.max_temp) ˚C"
        humidity.text = weather.humidity + "%"
        rainFall.text = weather.rainfall + "mm"
        weatherDescription.text = weather.description
        if startPlants!.count > 0, maxTemp > 35,startPlants!.count > 0{
            sendNotice(title: "Notice plant need water", body: "Today's highest temparature is \(maxTemp). The plants may need water!")
        }
        
    }
    //1.4.1 Send notice when harvest and abnormal weather
    func sendNotice(title:String, body: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "waterPlant", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
        })
    }
    
   
    //1.4.2 Notice set
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
    }
    
    //1.5.1 Update the harvest score
    func createScore(){
        var score = 0
        var co2 = 0
        for harvestScore in harvestScores!{
            score = score + harvestScore.score
            co2 = co2 + harvestScore.co2
        }
        
        co2Label.text = "\(co2)"
      
    }
    
    
    
    //1.6.1 Set prgress bare
    func progressBar(){
        fruitImage.isHidden = false
        fruitNameLabel.isHidden = false
        startlabel.isHidden = false
        harvestLabel.isHidden = false
        progressView.isHidden = false
        fruitImage.image = UIImage(named: startPlants![0].plantName)
        fruitNameLabel.text = startPlants![0].plantName
        let harvestDate = startPlants![0].harvestDate.asDate
        let nowDays = harvestDate.daysSinceNow.day!
        let totalDays = startPlants![0].harvestDay
        let percent = Double((Double(totalDays) - Double(nowDays)) / Double(totalDays))
        progressView.progress = Float(percent)
        if percent == 1.0 {
            sendNotice(title: "Harvest Day", body: "You have plants need to be harvested!")
        }
    }
    
    
   
    //1.7.1 Play image
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    //1.7.1 Play image
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
  //1.7.1 Play image
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.myImageView.image = UIImage(named: images[indexPath.item])
        
        return cell
    }
    //1.7.1 Play image
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    //1.7.1 Play image
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //1.7.1 Play image
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    //1.7.1 Play image
    @objc func changeBanner(){
        var indexPath:IndexPath
         imageIndex += 1
        if imageIndex < images.count{
           
            indexPath = IndexPath(item: imageIndex, section:0)
            myCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }else{
            imageIndex = 0
            indexPath = IndexPath(item: imageIndex, section:0)
            myCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
            changeBanner()
        }
      
    }

}

extension Date {
    /// Returns a DateComponent value with number of days away from a specified date
    var daysSinceNow: DateComponents {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd/MM/yyyy"
        return Calendar.current.dateComponents([.day], from: now, to: self)
    }
}

extension String {
    /// Returns a date from a string in MMMM dd, yyyy. Will return today's date if input is invalid.
    var asDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: self) ?? Date()
    }
}







