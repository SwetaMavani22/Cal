//
//  HomeVC.swift
//  GST
//
//  Created by ViPrak-Ankit on 28/01/22.
//

import UIKit
import CoreData

class HomeVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var lblPaymentReceived: UILabel!
    @IBOutlet weak var lblPaymentReceivable: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    // MARK: - Variable Decleration
    var arrInvoiceData = [CreateInvoice]()
    var lastCreateInvoice = Date()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchInvoiceHistoryData()
    }
    
    // MARK: - Private Method
    func setDefault() {
        
    }
    
    func fetchInvoiceHistoryData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CreateInvoice>(entityName: "CreateInvoice")
        do {
            arrInvoiceData = try context.fetch(fetchRequest)
            let paymentReceive = arrInvoiceData.filter({$0.invoice_payment_status == true}).map({$0.summary_total.roundToDecimal(3)}).reduce(0, +)
            let paymentReceivable = arrInvoiceData.filter({$0.invoice_payment_status == false}).map({$0.summary_total.roundToDecimal(3)}).reduce(0, +)
            lblPaymentReceived.text = "\(paymentReceive)"
            lblPaymentReceivable.text = "\(paymentReceivable)"
            lblTotal.text = "\(paymentReceive - paymentReceivable)"
        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.gotoCreateInvoiceVC(isUpdate: true, selectedInvoiceDate: CreateInvoice(), lastCreateInvoice: self.lastCreateInvoice, isLastCreateInvoice: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { action in
            self.gotoCreateInvoiceVC(isUpdate: false, selectedInvoiceDate: CreateInvoice(), lastCreateInvoice: Date(), isLastCreateInvoice: false)
        }))
        self.present(alert, animated: true, completion: nil)
    }


    // MARK: - Button Action
    @IBAction func clickToCreateNewInvoice(_ sender: UIButton) {
        
        if arrInvoiceData.count > 0 {
            if UserDefaults.standard.value(forKey:  UDKey.kLastInvoice) != nil{
                postAlert("GST Invoice", message: "Do you want to edit previous invoice?")
                self.lastCreateInvoice = UserDefaults.standard.value(forKey:  UDKey.kLastInvoice) as? Date ?? Date()
            } else {
                self.gotoCreateInvoiceVC(isUpdate: false, selectedInvoiceDate: CreateInvoice(), lastCreateInvoice: Date(), isLastCreateInvoice: false)
            }
        } else {
            self.gotoCreateInvoiceVC(isUpdate: false, selectedInvoiceDate: CreateInvoice(), lastCreateInvoice: Date(), isLastCreateInvoice: false)
        }
    }
    
    @IBAction func clickToInvoiceHistory(_ sender: UIButton) {
        self.gotoInvoiceHistoryVC()
    }
    
    @IBAction func clickToManageProducts(_ sender: UIButton) {
        self.gotoManageProductsVC()
    }
    
    @IBAction func clickToManageCustomers(_ sender: UIButton) {
        self.gotoManageCustomersVC()
    }
    
    @IBAction func clickToMyBusiness(_ sender: UIButton) {
        self.gotoMyBusinessVC()
    }
    
    @IBAction func clickToSettings(_ sender: UIButton) {
        self.gotoSettingsVC()
    }


}
