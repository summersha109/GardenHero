//
//  TestViewController.swift
//  GardenHero
//
//  Created by 朱莎 on 8/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func segments(_ sender: UISegmentedControl) {
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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
