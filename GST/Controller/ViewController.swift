//
//  ViewController.swift
//  GST
//
//  Created by Ketan on 30/01/2022.
//

import UIKit
import AdSupport
import AppTrackingTransparency


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func countineTapped(_ sender: UIButton) {
        if #available(iOS 14, *) {
            self.requestPermission()
        }
        else{
            self.gotoMyBusinessVC()
        }
    }

    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Authorized")
                    self.gotoMyBusinessVC()
                case .denied:
                    print("Denied")
                    self.gotoMyBusinessVC()
                case .notDetermined:
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }

}

