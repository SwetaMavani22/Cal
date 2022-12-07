//
//  OnboardingVC.swift
//  Photonic
//
//  Created by ViPrak-Ankit on 05/01/22.
//

import UIKit

class OnboardingVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var colOnboarding: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    
    // MARK: - Variable Decleration
    var currentIndex = 0
    var arrTitle = ["Most simple & powerful billing app", "Widely Accepted & Most Secure", "Quickly Generate & Share Invoice", "GST Tax Comptible Invoicing", "Allow Storage Permission"]
    var arrSubTitle = ["Fastest billing app which comes with products management, customers management, GST, email and invoice history.", "We don't save any of your information online for your safety. Used by Small Business, Retailers, Wholesales, Freelancers, Service Providers and many more...", "Using our billing app you can export data in PDF for future reference. PDF documents can be directly mailed from app itself.", "Our billing app is 100% compatible with GST regulations and user can generate multi-rates and multi-item invoices.", "GST Invoice needs storage permission to save Invoice PDFs to your internal storage."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    // MARK: - Private Method
    func setDefault() {
        colOnboarding.delegate = self
        colOnboarding.dataSource = self
    }
    
    // MARK: - Button Action
    @IBAction func clickToSkip(_ sender: UIButton) {
        self.gotoAppTrans()
    }
    
    @IBAction func clickToDone(_ sender: UIButton) {
        
        if (self.currentIndex == 4) {
            self.gotoAppTrans()
        } else {
            self.currentIndex += 1
            self.pageControl.currentPage = currentIndex
            self.btnSkip.isHidden = (currentIndex == 4) ? true : false
            self.btnDone.setTitle((currentIndex == 4) ? "Done" : "", for: .normal)
            self.btnDone.setImage((currentIndex == 4) ? UIImage.init() : UIImage.init(systemName: "chevron.forward"), for: .normal)
            
            let indexPath = IndexPath(item: self.currentIndex, section: 0)
            self.colOnboarding.scrollToItem(at: indexPath, at: .left, animated: true)
        }
    }
}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = self.colOnboarding.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell {
            cell.lblTitle.text = self.arrTitle[indexPath.row]
            cell.lblSubTitle.text = self.arrSubTitle[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: colOnboarding.frame.size.width, height: colOnboarding.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageControl.currentPage = currentIndex
        self.btnSkip.isHidden = (currentIndex == 4) ? true : false
        self.btnDone.setTitle((currentIndex == 4) ? "Done" : "", for: .normal)
        self.btnDone.setImage((currentIndex == 4) ? UIImage.init() : UIImage.init(systemName: "chevron.forward"), for: .normal)
    }
}
