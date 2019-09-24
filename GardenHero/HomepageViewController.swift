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



class ViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var tempreature: UILabel!
    @IBOutlet weak var rainFall: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var humidity: UILabel!
    
   
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var co2Label: UILabel!
    
    let weatherAppid = "225f741930286a60f40c542da28f069a"
    let locationManager = CLLocationManager()
    let weather = Weather()
    let realm = try! Realm()
    
   
    let images = ["1","2","3","4","5","6","1"]
    
    var imageIndex = 0
    var harvestScores: Results<HarvestScore>?
    
    let client = TCPClient(address: "3.104.105.21", port: 9999)
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self // viewcontroller is loction manager delegate
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
        harvestScores = realm.objects(HarvestScore.self)
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        locationManager.requestWhenInUseAuthorization() //Ask user authorizete loction
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // The accurancy is 100m
        locationManager.requestLocation() // Only request user once
        createScore()
    }
    
    //Ask user's location method.
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = locations[0].coordinate.latitude // Get latitude
        let lon = locations[0].coordinate.longitude // Get longitude
        print(lat,lon)
        let paras = ["lat":"\(lat)","lon":"\(lon)","appid":weatherAppid]
        getWeather(paras: paras)
    }
    
    // We must add didFailWithErro function
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // Request api and get data
    func getWeather(paras:[String:String]){
        
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast", parameters: paras).responseJSON { response in
            
            if let json = response.result.value {
                let weather = JSON(json)
                
                self.createWeather(weatherJSON : weather)
                self.updateUI()
            }
        }
    }
    
    func createWeather(weatherJSON:JSON){
      weather.description = weatherJSON["list"][1]["weather"][0]["description"].stringValue
       weather.humidity = weatherJSON["list"][1]["main"]["humidity"].stringValue
        weather.max_temp = Int(round(weatherJSON["list"][1]["main"]["temp_max"].doubleValue) - 273.15)
        weather.min_temp = Int(round(weatherJSON["list"][1]["main"]["temp_min"].doubleValue) - 273.15)
        weather.rainfall = weatherJSON["list"][1]["rain"]["3h"].stringValue
    }
    
    func updateUI(){
        tempreature.text = "\(weather.min_temp) " + "-" + "\(weather.max_temp) ˚C"
        humidity.text = weather.humidity + "%"
        rainFall.text = weather.rainfall + "mm"
        weatherDescription.text = weather.description
        
    }
    
    func createScore(){
        var score = 0
        var co2 = 0
        for harvestScore in harvestScores!{
            score = score + harvestScore.score
            co2 = co2 + harvestScore.co2
        }
        
        co2Label.text = "\(co2)"
      
    }
    
   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        cell.myImageView.image = UIImage(named: images[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
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
    
    
    @IBAction func takePhotoButton(_ sender: Any) {
        showChooseSourceTypeAlertController()
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
            case .failure(let error):
                print(error)
            }
        case .failure(let error):
            print(error)
            }
      
        }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showChooseSourceTypeAlertController() {
        let photoLibraryAction = UIAlertAction(title: "Choose a Photo", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take a New Photo", style: .default) { (action) in
          
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertService.showAlert(style: .actionSheet, title: nil, message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
           
            let imageData:Data = editedImage.pngData()!
            let imageStr = imageData.base64EncodedString()
            connectServer(request: "PNG" + imageStr)
            
            print("PNG" + imageStr)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let diagnosisVc = storyboard.instantiateViewController(withIdentifier: "Diagnosis") as! DiagnosisViewController
            self.navigationController?.pushViewController(diagnosisVc, animated: true)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageData:Data = originalImage.pngData()!
            let imageStr = imageData.base64EncodedString()
            connectServer(request: "PNG" + imageStr + "!")
            print("PNG" + imageStr + "!")
            //print("\(originalImage.withRenderingMode(.alwaysOriginal))")
          // diagnoseImage.image = originalImage.withRenderingMode(.alwaysOriginal)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let diagnosisVc = storyboard.instantiateViewController(withIdentifier: "Diagnosis") as! DiagnosisViewController
            self.navigationController?.pushViewController(diagnosisVc, animated: true)
        }
        dismiss(animated: true, completion: nil)
    }
}






