//
//  SummaryVC.swift
//  GST
//
//  Created by ViPrak-Ankit on 28/01/22.
//

import UIKit
import CoreData

class SummaryVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtSubTotal: AkiraTextField!
    @IBOutlet weak var txtIGST: AkiraTextField!
    @IBOutlet weak var txtCGST: AkiraTextField!
    @IBOutlet weak var txSGST: AkiraTextField!
    @IBOutlet weak var txtShippingCharges: AkiraTextField!
    @IBOutlet weak var txtDiscount: AkiraTextField!
    @IBOutlet weak var txtTotal: AkiraTextField!
    
    // MARK: - Variable Decleration
    var isGST = false
    var isUpdate = false
    var Invoice_UID = Date()
    var invoiceDetail: NSManagedObject?
    var selectedInvoiceDate = CreateInvoice()
    var lastCreateInvoice = Date()
    var isLastCreateInvoice = false
    var isStateMatch =  false
    var arrProductData = [ManageInvoiceProduct]()
    var CGST = 0.0
    var SGST = 0.0
    var IGST = 0.0
    var Total = 0.0
    var subTotal = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isLastCreateInvoice {
            self.Invoice_UID = lastCreateInvoice
        }
              
        if isGST {
            if isStateMatch {
                txtCGST.isHidden = false
                txSGST.isHidden = false
                txtIGST.isHidden = true
            } else {
                txtIGST.isHidden = false
                txtCGST.isHidden = true
                txSGST.isHidden = true
            }
        } else {
            txtCGST.isHidden = true
            txSGST.isHidden = true
            txtIGST.isHidden = true
        }

        if isUpdate {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<CreateInvoice>(entityName: "CreateInvoice")
            fetchRequest.predicate = NSPredicate(format: "invoice_id = %@", Invoice_UID as CVarArg )
            do
            {
                let value = try  context.fetch(fetchRequest)
                let product = value[0] as NSManagedObject
                
                txtDiscount.text = "\(product.value(forKey: "summary_discount") as? Double ?? 0.0)"
                txtShippingCharges.text = "\(product.value(forKey: "summary_shippingCharge") as? Double ?? 0.0)"
            }catch{
                print(error)
                self.view.makeToast("Invoice Not Update.")
            }
        }
        
        self.fetchProductData(invoice_id : Invoice_UID)
        
    }
    
    // MARK: - Private Method
    func setDefault() {
        
    }
    
    func AddSummary() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
                
        if let invoiceDetail = invoiceDetail {
            invoiceDetail.setValue(Double(txtTotal.text ?? "")?.roundToDecimal(3), forKey: "summary_total")
            invoiceDetail.setValue(Double(txtDiscount.text ?? "")?.roundToDecimal(3), forKey: "summary_discount")
            invoiceDetail.setValue(Double(txtIGST.text ?? "")?.roundToDecimal(3), forKey: "summary_igst")
            invoiceDetail.setValue(Double(txtShippingCharges.text ?? "")?.roundToDecimal(3), forKey: "summary_shippingCharge")
            invoiceDetail.setValue(subTotal.roundToDecimal(3), forKey: "summary_subtotal")
            invoiceDetail.setValue(Double(txtCGST.text ?? "")?.roundToDecimal(3), forKey: "summary_cgst")
            invoiceDetail.setValue(Double(txSGST.text ?? "")?.roundToDecimal(3), forKey: "summary_sgst")
        }
        do {
            try context.save()
            //self.gotoHomeVC()
            GetInvoiceDataForPDF()
            UserDefaults.standard.set(Invoice_UID, forKey: UDKey.kLastInvoice)
            UserDefaults.standard.synchronize()
        } catch let error as NSError {
            self.view.makeToast("Invoice Not Save.")
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetchProductData(invoice_id: Date) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ManageInvoiceProduct>(entityName: "ManageInvoiceProduct")
        fetchRequest.predicate = NSPredicate(format: "invoice_product_id = %@", invoice_id as CVarArg)
        do {
            arrProductData = try context.fetch(fetchRequest)
            var d2 = 0.0
            for item in arrProductData {
                d2 = (Double(item.invoice_product_gst ?? "0.0") ?? 0.0)/2
                self.subTotal = arrProductData.map({Double($0.invoice_product_total ?? "")?.roundToDecimal(3) ?? 0.0}).reduce(0, +)
                self.CGST += (d2 * (Double(item.invoice_product_total ?? "0.0") ?? 0.0))/100
                self.SGST += (d2 * (Double(item.invoice_product_total ?? "0.0") ?? 0.0))/100
            }
            
            if isGST {
                self.IGST = self.CGST+self.SGST
                txtIGST.text = "\(self.IGST)"
                txtCGST.text = "\(self.CGST)"
                txSGST.text = "\(self.SGST)"
                txtSubTotal.text = "\(self.subTotal)"
                let shippingCharge = Double(txtShippingCharges.text ?? "")?.roundToDecimal(3) ?? 0.0
                let discount = Double(txtDiscount.text ?? "")?.roundToDecimal(3) ?? 0.0
                txtTotal.text = "\(self.subTotal+self.IGST+shippingCharge-discount)"
                self.Total = Double(txtTotal.text ?? "0.0") ?? 0.0
            } else {
                txtSubTotal.text = "\(self.subTotal)"
                let shippingCharge = Double(txtShippingCharges.text ?? "")?.roundToDecimal(3) ?? 0.0
                let discount = Double(txtDiscount.text ?? "")?.roundToDecimal(3) ?? 0.0
                txtTotal.text = "\(self.subTotal-shippingCharge+discount)"
                self.Total = Double(txtTotal.text ?? "0.0") ?? 0.0
            }
            
        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }

    func GetInvoiceDataForPDF() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CreateInvoice>(entityName: "CreateInvoice")
        fetchRequest.predicate = NSPredicate(format: "invoice_id = %@", Invoice_UID as CVarArg )

        do {
            let value = try context.fetch(fetchRequest)
            self.gotoInvoiceVC(billProductData: arrProductData, invoiceData: value[0])

        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }
    
    // MARK: - Button Action
    @IBAction func clickToBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToGenerateInvoice(_ sender: UIButton) {
        
        AddSummary()
    }

}

extension SummaryVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
         if textField == txtShippingCharges {
            if let textShipping = txtShippingCharges.text,
               let textRangeShipping = Range(range, in: textShipping) {
                let txtShip = textShipping.replacingCharacters(in: textRangeShipping,with: string)
                let shippingCharge = Double(txtShip) ?? 0.0
                let discount = Double(txtDiscount.text ?? "0.0") ?? 0.0
                if isGST {
                    let total = self.subTotal + shippingCharge - discount + self.IGST
                    txtTotal.text = "\(total.roundToDecimal(3))"
                } else {
                    let total = self.subTotal + shippingCharge - discount
                    txtTotal.text = "\(total.roundToDecimal(3))"
                }
            }
         } else if  textField == txtDiscount {
             if let textDiscount = txtDiscount.text,
                let textRangeDiscount = Range(range, in: textDiscount) {
                 let txtDis = textDiscount.replacingCharacters(in: textRangeDiscount,with: string)
                 let discount = Double(txtDis) ?? 0.0
                 let shippingCharge = Double(txtShippingCharges.text ?? "0.0") ?? 0.0
                 if isGST {
                     let total = self.subTotal - discount + shippingCharge + self.IGST
                     txtTotal.text = "\(total.roundToDecimal(3))"
                 } else {
                     let total = self.subTotal - discount + shippingCharge
                     txtTotal.text = "\(total.roundToDecimal(3))"
                 }
             }
         }
        return true
    }
}
