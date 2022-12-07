//
//  SettingsVC.swift
//  GST
//
//  Created by ViPrak-Ankit on 28/01/22.
//

import UIKit
import StoreKit

class SettingsVC: UIViewController {
    
    // MARK: - Outlets
    
    // MARK: - Variable Decleration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    // MARK: - Private Method
    func setDefault() {
        
    }
    
    // MARK: - Button Action
    @IBAction func clickToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToShare(_ sender: UIButton) {
        if let AppURL = NSURL(string:"https://itunes.apple.com/us/app/mindtastik-easy-meditation/id1454780254") {
            let shareAll = [appName, AppURL] as [Any]
            
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.present(activityViewController, animated: true, completion: nil)
                if let popOver = activityViewController.popoverPresentationController {
                    popOver.sourceView = self.view
                    popOver.sourceRect = sender.frame
                }
            } else {
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func clickToRate(_ sender: UIButton) {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else {
            SKStoreReviewController.requestReview()
        }
    }
    
    @IBAction func clickToMore(_ sender: UIButton) {
        
    }
    
}
