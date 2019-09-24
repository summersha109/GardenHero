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
    var digResult: String?
    override func viewDidLoad() {
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
    
    func setResult(){
        
        
        let finalImage = image!.resizedTo1MB()
        let imageData: Data = finalImage!.pngData()!
        let number = imageData.count
        //let testImage = UIImage(named: "test3")
        //let imageData:Data = testImage!.pngData()!
        
        
        
        let imageStr = imageData.base64EncodedString()
        
        let imageEncode = imageData.base64EncodedString(options: .lineLength64Characters)
        
        //let long = String(imageStr.count)
        //print(long)
        let digResult = self.connectServer(request: "PNG", imageString: imageStr)
        print(digResult)
        
        activityIndicator.stopAnimating()
        result.text = digResult
        
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
                    sleep(8)
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
