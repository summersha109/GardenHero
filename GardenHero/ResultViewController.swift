//
//  ResultViewController.swift
//  GardenHero
//
//  Created by 朱莎 on 19/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import SwiftSocket

class ResultViewController: UIViewController {
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let client = TCPClient(address: "3.104.105.21", port: 9999)
    var image: UIImage?
    @IBOutlet weak var result: UILabel!
    
    @IBOutlet weak var resultImage: UIImageView!
    
    @IBOutlet weak var diseasesLabel: UILabel!
    
    @IBOutlet weak var diseaseText: UILabel!
    
    @IBOutlet weak var treatementLabel: UILabel!
    
    @IBOutlet weak var treatementText: UILabel!
    
    let treatementDic = ["Apple Scab": "1.Rake under trees and destroy infected leaves.\r2.Water in the evening or early morning hours to give the leaves time to dry out before infection can occur.\r3.Spread a 3 to 6-inchlayer of compostunder trees, keeping it away from the trunk.\r4.Spray liquid copper fungicide in 7 to 10-day intervals.5.Use systemic fungicide as a soil drench or spray (3-4 tsp/ gallon of water)",
                         "Bacterial Spot": "1.Remove affected leaves at first sight.\r2.Use copper fungicides.\r3.Remove old vegetable debris.\r4.There are no recognized chemical treatments for bacterial leaf spot disease. The best bet is prevention and mechanical control at the first signof symptoms of bacterial leaf spot",
                         "Black Rot": "1.Remove infected plant parts immediately.\r2.Prune out any and all areas with lesions.\r3.Apply copper fungicides using spray treatment.",
                         "Cedar Apple Rust": "1.Remove galls from infected junipers.\r2.Rake up debris on ground.\r3.Rust can be controlled by spraying plants with a copper solution (0.5 to 2.0oz/ gallon of water) fortnightly.\r4.Use broad spectrum bio-fungicide such as Serenade Garden.\r5.Use fungicide containing sulphur and pyrethrin such as Bonide Orchard Spray. Use 5 oz/gallon of water.",
                         "Cercospora Leaf Spot":"1.Apply copper fungicides or sulphur-based fungicides such as Bonide Orchard Spray.\r2.Treatment is not easy and it is recommended to discard the plant if more than 20% is affected", "Common Rust": "1.Discard affected leaves and rake debris of the ground. Add a thick layer of compost or mulch when ground in raked.\r2.Use slow release organic fertilizer on crops and avoid excess nitrogen.\r3.Prune plants and remove weeds.\r4.Use copper or sulphur-based fungicides every 7 to 10 days till harvest.5.Do NOT compost infected plants.",
                         "Early Blight" : "1.Prune the plants. Make sure to disinfect yourpruning shears(one part bleach to 4 parts water) after each cut.\r2.Clear ground debris and cover it with a layer of mulch or compost.\r3.Use copper-based fungicides every 7 to 10 days.\r4.Do NOT compost infected plants",
                         "Esca (Black Measles)" : "1.Prune the plant and rake debris of the ground.\r2.This disease is not easily treated by chemicals and hence should be prevented using specialized waxes containing plant growth regulators.",
                         "Haunglongbing (Citrus Greening)" : "1.There is no known cure. Destroy affected plants immediately.",
                         "Late Blight" : "1.Try to increase spacing to give more air circulation and water early in the day to give time to dry out.\r2.Apply acopper based fungicide(2 oz/ gallon of water) every 7 days or less.\r3.Use a foliar spray such as Organocide Plant Doctor (2 tsp/ gallon of water) every 1-2 weeks",
                         "Leaf Mold": "1.Increase air circulation by pruning plants.\r2.Rake fallen debris and cover with mulch or compost.\r3.Water early to leave time for drying.\r4.Copper-Soap fungicides(every 7-10 days) will help by protecting plants from disease spores.\r5.Potassium bicarbonate fungicides such as Green Cure Fungicide will help kill the fungus (1-2 tsp/ gallon water every 1-2 weeks).",
                         "Leaf Scorch" : "1.Water heavily during dry days.\r2.Lock in soil moisture by mulching.\r3.Provide adequate micro-nutrients to soil (iron or manganese).",
                         "Mosaic Virus":"1.There is no cure for this virus. Discard infected plants immediately.\r2.Do NOT compost infected plants.\r3.To prevent, remove all perennial weeds and look for resistant plant varieties from a reputable source.\r4.Spot treat with least-toxic, natural pest control products, such as Safer Soap, to reduce the number of disease carrying insects.",
                         "Northern Leaf Blight": "1.Increase spacing and prune plants to increase air flow circulation.\r2.Make sure plants do not stay damp for more than 8 hours.\r3.Use copper or sulphur-based fungicides if infection is severe.\r4.Discard infected plants.",
                         "Powdery Mildew" : "1.Prune or stake plants to improve air circulation.Make sure to disinfect yourpruning tools(one part bleach to 4 parts water) after each cut.\r2.Discard infected plants and clear fallen debris. Cover with mulch or compost after clearing.\r3.Milk sprays, made with 40% milk and 60% water,are an effective home remedy. Apply every 10-14 days.\r4.Wash foliage occasionallytodisrupt the daily spore-releasing cycle.Neem oilandPM Wash, used on a 7 day schedule, will prevent fungal attack on plants grown indoors.\r5.Use aslow-release,organic fertilizeron cropsand avoid excessnitrogen.\r6.If symptoms are severe, use copper or sulphur-based fungicides or Green Cure Fungicide whichcontains a patented formula of potassium bicarbonate. Indoor growers may want to consider using aSulphur Burner/Vaporizer",
                         "Septoria Leaf Spot":"1.Immediately discard infected leaves.\r2.Fungicides containing either copper or potassium bicarbonate will help prevent the spreading of the disease.\r3.While chemical options are not ideal, they may be the only option for controlling advanced infections. One of the least toxic and most effective ischlorothalonil(sold under the names Fungonil andDaconil).",
                         "Spider Mites":"1.One natural spider mite remedy is to simply spray down the plant with a nozzled hose.\r2.Another effective spider mite treatment is to use an insecticidal oil, like neem oil, a horticultural oil or a dormant oil. You can also try using a miticide, as this will kill them.\r3.Do NOT use pesticides as spider mites are resistant to it.",
                         "Yellow Leaf Curl Virus":"1.Leaf curl can be controlled by applyingsulphurorcopper-based fungicides.\r2.Rake fallen debris and destroy infected plant parts.\r3.Containing copper and pyrethrins,Bonide Garden Dustis a safe, one-step control for many insect attacks and fungal problems.10 oz will cover 625 sq. ft. Repeat applications every 7-10 days, as needed.\r4.If disease problems are severe, maintain tree health by cutting back more fruit than normal, watering regularly (avoiding wetting the leaves if possible) and apply anorganic fertilizers high in nitrogen"]
    var digResult: String?
    override func viewDidLoad() {
        diseasesLabel.isHidden = true
        diseaseText.isHidden = true
        treatementLabel.isHidden = true
        treatementText.isHidden = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.center = self.view.center
        activityIndicator.style = .gray
        
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: activityIndicator.superview!.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: activityIndicator.superview!.centerYAnchor).isActive = true
        activityIndicator.restorationIdentifier = "indicator"
        super.viewDidLoad()
        let queue = DispatchQueue.global()
        
        queue.async {
            self.setResult()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setResult(){
        
        
        let finalImage = image!.resizedTo1MB()
        let imageData: Data = finalImage!.pngData()!
        let imageStr = imageData.base64EncodedString()
        let digResult = self.connectServer(request: "PNG", imageString: imageStr)
        
       activityIndicator.stopAnimating()
        if digResult == "Healthy"{
            resultImage.image = UIImage(named: "smile_face")
            result.text = digResult
        } else {
            result.text = "Unhealthy"
             resultImage.image = UIImage(named: "unhealthy_face")
            diseasesLabel.isHidden = false
            diseaseText.isHidden = false
            treatementLabel.isHidden = false
            treatementText.isHidden = false
            diseaseText.text = digResult
            treatementText.text = treatementDic[digResult]
        }
        
        
    }
    
    func connectServer(request: String, imageString: String) -> String {
        var result: String?
        switch client.connect(timeout: 10) {
        case .success:
            print("success")
            switch client.send(string: request ) {
            case .success:
                //DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute:{
                switch self.client.send(string: imageString) {
                case .success:
                    print("image success")
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute:{
                    sleep(3)
                    switch self.client.send(string: request) {
                    case .success:
                        print("end")
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                    
                case .failure(let error):
                    print(error)
                }
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
                result = "Error"
                print(error)
                
            }
        case .failure(let error):
            result = "Error"
            print(error)
            
        }
        return result!
    }
}
