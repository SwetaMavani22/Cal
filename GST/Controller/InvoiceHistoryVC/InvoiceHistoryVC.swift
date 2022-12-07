//
//  InvoiceHistoryVC.swift
//  GST
//
//  Created by Ketan on 30/01/2022.
//

import UIKit
import CoreData

class InvoiceHistoryVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tblInvoiceHistory: UITableView!
    
    // MARK: - Variable Decleration
    var arrInvoiceData = [CreateInvoice]()
    var selectedInvoice = CreateInvoice()
    var arrProductData = [ManageInvoiceProduct]()
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"

        setDefault()
    }
    
    // MARK: - Private Method
    func setDefault() {
        tblInvoiceHistory.delegate = self
        tblInvoiceHistory.dataSource = self
        tblInvoiceHistory.estimatedRowHeight = UITableView.automaticDimension
        
        fetchInvoiceHistoryData()
    }
    
    func fetchInvoiceHistoryData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CreateInvoice>(entityName: "CreateInvoice")
        do {
            arrInvoiceData = try context.fetch(fetchRequest)
            self.tblInvoiceHistory.reloadData()
        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }
    
    func postAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            self.UpdateStatus(selectedInvoice: self.selectedInvoice)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func UpdateStatus(selectedInvoice: CreateInvoice) {
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CreateInvoice>(entityName: "CreateInvoice")
        fetchRequest.predicate = NSPredicate(format: "invoice_id = %@", selectedInvoice.invoice_id! as CVarArg )
        do
        {
            let value = try  context.fetch(fetchRequest)
            let invoice = value[0] as NSManagedObject
            invoice.setValue(selectedInvoice.invoice_isGST, forKey: "invoice_isGST")
            invoice.setValue(selectedInvoice.invoice_id, forKey: "invoice_id")
            invoice.setValue(selectedInvoice.invoice_accountno, forKey: "invoice_accountno")
            invoice.setValue(selectedInvoice.invoice_address, forKey: "invoice_address")
            invoice.setValue(selectedInvoice.invoice_bankname, forKey: "invoice_bankname")
            invoice.setValue(selectedInvoice.invoice_city, forKey: "invoice_city")
            invoice.setValue(selectedInvoice.invoice_date, forKey: "invoice_date")
            invoice.setValue(selectedInvoice.invoice_deliverydate, forKey: "invoice_deliverydate")
            invoice.setValue(selectedInvoice.invoice_deliverynote, forKey: "invoice_deliverynote")
            invoice.setValue(selectedInvoice.invoice_deliveryterms, forKey: "invoice_deliveryterms")
            invoice.setValue(selectedInvoice.invoice_destination, forKey: "invoice_destination")
            invoice.setValue(selectedInvoice.invoice_dispatchdocno, forKey: "invoice_dispatchdocno")
            invoice.setValue(selectedInvoice.invoice_dispatchthrough, forKey: "invoice_dispatchthrough")
            invoice.setValue(selectedInvoice.invoice_email, forKey: "invoice_email")
            invoice.setValue(selectedInvoice.invoice_eway, forKey: "invoice_eway")
            invoice.setValue(selectedInvoice.invoice_gst, forKey: "invoice_gst")
            invoice.setValue(selectedInvoice.invoice_ifsc, forKey: "invoice_ifsc")
            invoice.setValue(selectedInvoice.invoice_name, forKey: "invoice_name")
            invoice.setValue(selectedInvoice.invoice_no, forKey: "invoice_no")
            invoice.setValue(selectedInvoice.invoice_other, forKey: "invoice_other")
            invoice.setValue(selectedInvoice.invoice_pan, forKey: "invoice_pan")
            invoice.setValue(selectedInvoice.invoice_phone, forKey: "invoice_phone")
            invoice.setValue(selectedInvoice.invoice_receiver_address, forKey: "invoice_receiver_address")
            invoice.setValue(selectedInvoice.invoice_receiver_city, forKey: "invoice_receiver_city")
            invoice.setValue(selectedInvoice.invoice_receiver_email, forKey: "invoice_receiver_email")
            invoice.setValue(selectedInvoice.invoice_receiver_gst, forKey: "invoice_receiver_gst")
            invoice.setValue(selectedInvoice.invoice_receiver_name, forKey: "invoice_receiver_name")
            invoice.setValue(selectedInvoice.invoice_receiver_pan, forKey: "invoice_receiver_pan")
            invoice.setValue(selectedInvoice.invoice_receiver_phone, forKey: "invoice_receiver_phone")
            invoice.setValue(selectedInvoice.invoice_receiver_state, forKey: "invoice_receiver_state")
            invoice.setValue(selectedInvoice.invoice_receiver_zipcode, forKey: "invoice_receiver_zipcode")
            invoice.setValue(selectedInvoice.invoice_state, forKey: "invoice_state")
            invoice.setValue(selectedInvoice.invoice_supplier, forKey: "invoice_supplier")
            invoice.setValue(selectedInvoice.invoice_termsandcondition, forKey: "invoice_termsandcondition")
            invoice.setValue(selectedInvoice.invoice_termsofpayment, forKey: "invoice_termsofpayment")
            invoice.setValue(selectedInvoice.invoice_zipcode, forKey: "invoice_zipcode")
            if selectedInvoice.invoice_payment_status {
                invoice.setValue(false, forKey: "invoice_payment_status")
            } else {
                invoice.setValue(true, forKey: "invoice_payment_status")
            }
            invoice.setValue(selectedInvoice.summary_total, forKey: "summary_total")
            invoice.setValue(selectedInvoice.summary_discount, forKey: "summary_discount")
            invoice.setValue(selectedInvoice.summary_igst, forKey: "summary_igst")
            invoice.setValue(selectedInvoice.summary_shippingCharge, forKey: "summary_shippingCharge")
            invoice.setValue(selectedInvoice.summary_subtotal, forKey: "summary_subtotal")

            do {
                try context.save()
                fetchInvoiceHistoryData()
            } catch let error as NSError {
                self.view.makeToast("Invoice Not Update.")
                print("Could not save. \(error), \(error.userInfo)")
            }

        }catch{
            print(error)
            self.view.makeToast("Product Not Update.")
        }
    }
    
    func fetchInvoiceData(invoicedata : CreateInvoice) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ManageInvoiceProduct>(entityName: "ManageInvoiceProduct")
        fetchRequest.predicate = NSPredicate(format: "invoice_product_id = %@", invoicedata.invoice_id! as CVarArg)
        do {
            arrProductData = try context.fetch(fetchRequest)
            self.gotoInvoiceVC(billProductData: arrProductData, invoiceData: invoicedata)
        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }
    
    // MARK: - Button Action
    @IBAction func clickToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func clickToView(_ sender: UIButton) {
        
        fetchInvoiceData(invoicedata: arrInvoiceData[sender.tag])
    }

    @IBAction func clickToEdit(_ sender: UIButton) {
        
        self.gotoCreateInvoiceVC(isUpdate: true, selectedInvoiceDate: arrInvoiceData[sender.tag], lastCreateInvoice: Date(), isLastCreateInvoice: false)
    }

    @IBAction func clickToChangeStatus(_ sender: UIButton) {
        
        selectedInvoice = arrInvoiceData[sender.tag]
        postAlert("GST Invoice", message: "Do you want to mark invoice  as Payment Received.")
    }
    
    @IBAction func clickToDelete(_ sender: UIButton) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(arrInvoiceData[sender.tag])
        do {
            try  context.save()
            arrInvoiceData.remove(at: sender.tag)
            fetchInvoiceHistoryData()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }

    @IBAction func clickToShare(_ sender: UIButton) {
        
        let path = "\(NSTemporaryDirectory())\(dateFormatter.string(from: arrInvoiceData[sender.tag].invoice_id ?? Date())).pdf"
        
        if FileManager.default.fileExists(atPath: path) {
           let pdfData = NSData(contentsOfFile: path)
            let activityViewController = UIActivityViewController(activityItems: [pdfData as Any], applicationActivities: nil)
            present(activityViewController, animated: true) {() -> Void in }
        }
    }

}

extension InvoiceHistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrInvoiceData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblInvoiceHistory.dequeueReusableCell(withIdentifier: "InvoiceHistoryCell", for: indexPath) as? InvoiceHistoryCell {
            
            cell.lblInvoiceNo.text = "Invoice No : \(arrInvoiceData[indexPath.row].invoice_no ?? "")"
            cell.lblInvoiceName.text = arrInvoiceData[indexPath.row].invoice_receiver_name
            cell.lblInvoiceDate.text = "Date : \(arrInvoiceData[indexPath.row].invoice_date ?? "")"
            cell.lblInvoiceStatus.text = arrInvoiceData[indexPath.row].invoice_payment_status ? "Payment Received" : "Payment Receivable"
            cell.lblInvoiceStatus.textColor = arrInvoiceData[indexPath.row].invoice_payment_status ? UIColor.green : UIColor.red
            cell.lblInvoiceAmount.text = "\(arrInvoiceData[indexPath.row].summary_total)"
            cell.lblInvoicePDF.text = "\(dateFormatter.string(from: arrInvoiceData[indexPath.row].invoice_id ?? Date())).pdf"
            cell.btnView.tag = indexPath.row
            cell.btnEdit.tag = indexPath.row
            cell.btnChangeStatus.tag = indexPath.row
            cell.btnDelete.tag = indexPath.row
            cell.btnShare.tag = indexPath.row
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
