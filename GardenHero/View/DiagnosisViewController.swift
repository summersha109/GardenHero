//
//  DiagnosisViewController.swift
//  GardenHero
//
//  Created by 朱莎 on 16/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class DiagnosisViewController: UIViewController{
    //var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func takePhotoBtn(_ sender: Any) {
        showChooseSourceTypeAlertController()
        
    }
    
}

extension DiagnosisViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVc = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            detailVc.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            detailVc.image = originalImage
        
        }
        /*
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            let finalImage = editedImage.resizedTo1MB()
            let imageData: Data = finalImage!.pngData()!
            let number = imageData.count
            //let testImage = UIImage(named: "test3")
            //let imageData:Data = testImage!.pngData()!
            
            
            
            let imageStr = imageData.base64EncodedString()
            
            let imageEncode = imageData.base64EncodedString(options: .lineLength64Characters)
            
            //let long = String(imageStr.count)
            //print(long)
            result = self.connectServer(request: "PNG", imageString: imageStr)
            print(result)
            
            
            //                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //                let detailVc = storyboard.instantiateViewController(withIdentifier: "Result") as! ResultViewController
            //                detailVc.digResult = result
            //                 //          activityIndicator.stopAnimating()
            //                UIApplication.shared.endIgnoringInteractionEvents()
            //               self.navigationController?.pushViewController(detailVc, animated: true)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let finalImage = originalImage.resizedTo1MB()
            let imageData: Data = finalImage!.pngData()!
            let number = imageData.count
            //let testImage = UIImage(named: "test3")
            //let imageData:Data = testImage!.pngData()!
            let imageStr = imageData.base64EncodedString()
            let imageEncode = imageData.base64EncodedString(options: .lineLength64Characters) //imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            //let long = String(imageStr.count)
            //print(long)
            
            result = self.connectServer(request: "PNG", imageString: imageStr)
            print(result)
            
        }
        */
        self.navigationController?.pushViewController(detailVc, animated: true)
        
        
        dismiss(animated: true, completion: nil)
    }
}
