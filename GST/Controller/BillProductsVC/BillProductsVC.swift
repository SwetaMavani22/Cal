//
//  BillProductsVC.swift
//  GST
//
//  Created by ViPrak-Ankit on 28/01/22.
//

import UIKit
import CoreData

class BillProductsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tblBillProduct: UITableView!
    
    @IBOutlet weak var lblSubTotal: UILabel!

    // MARK: - Variable Decleration
    var isGST = false
    var arrProductData = [ManageInvoiceProduct]()
    var Invoice_UID = Date()
    var subTotal = 0.0
    var isUpdate = false
    var selectedInvoiceDate = CreateInvoice()
    var invoiceDetail: NSManagedObject?
    var lastCreateInvoice = Date()
    var isLastCreateInvoice = false
    var isStateMatch =  false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isLastCreateInvoice {
            self.fetchProductData(invoice_id: lastCreateInvoice)
        } else {
            self.fetchProductData(invoice_id : Invoice_UID)
        }
    }
    // MARK: - Private Method
    func setDefault() {
        
        tblBillProduct.delegate = self
        tblBillProduct.dataSource = self
        tblBillProduct.estimatedRowHeight = UITableView.automaticDimension
        
        lblSubTotal.text = "Sub Total \n 0.0"
    }
    
    func fetchProductData(invoice_id : Date) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let fetchRequest = NSFetchRequest<ManageInvoiceProduct>(entityName: "ManageInvoiceProduct")
            fetchRequest.predicate = NSPredicate(format: "invoice_product_id = %@", invoice_id as CVarArg)
            arrProductData = try context.fetch(fetchRequest)
            subTotal = arrProductData.map({Double($0.invoice_product_total ?? "")?.roundToDecimal(3) ?? 0.0}).reduce(0, +)
            lblSubTotal.text = "Sub Total \n \(subTotal)"
            self.tblBillProduct.reloadData()
        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }
    
    func deleteProductData(selectedProduct : ManageInvoiceProduct , index : Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(selectedProduct)
        
        do {
            try  context.save()
            arrProductData.remove(at: index)
            
            if isLastCreateInvoice {
                self.fetchProductData(invoice_id: lastCreateInvoice)
            } else {
                self.fetchProductData(invoice_id : Invoice_UID)
            }
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    // MARK: - Button Action
    @IBAction func clickToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddProduct(_ sender: UIButton) {
        self.gotoInvoiceAddProductVC(isGST: self.isGST , isUpdate: false, selectedProduct:  ManageInvoiceProduct(), Invoice_UID: self.Invoice_UID)
    }
    
    @IBAction func clickToNext(_ sender: UIButton) {
        
        if arrProductData.count > 0 {
            self.gotoSummaryVC(isGST: self.isGST, Invoice_UID: self.Invoice_UID, subTotal: self.subTotal, isUpdate: self.isUpdate,invoiceDetail: self.invoiceDetail, selectedInvoiceDate: self.selectedInvoiceDate,lastCreateInvoice: self.lastCreateInvoice , isLastCreateInvoice : self.isLastCreateInvoice, isStateMatch: self.isStateMatch)
        } else {
            self.view.makeToast("Please Add Product.")
        }
    }
}

extension BillProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProductData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblBillProduct.dequeueReusableCell(withIdentifier: "BillProductsCell", for: indexPath) as? BillProductsCell {
            
            cell.lblProductName.text = arrProductData[indexPath.row].invoice_product_name
            cell.lblProductHSN.text = "HSN/SAS : \(arrProductData[indexPath.row].invoice_product_hsn ?? "")"
            cell.lblProductGST.text = "GST % : \(arrProductData[indexPath.row].invoice_product_gst ?? "")"
            
            if let paymentReceive = Double(arrProductData[indexPath.row].invoice_product_quantity ?? "0.0") , let price =  Double(arrProductData[indexPath.row].invoice_product_price ?? "0.0") {
                cell.lblProductUnit.text = "\(paymentReceive) \(arrProductData[indexPath.row].invoice_product_unit ?? "") x \(price)"
            }
            
            cell.lblProductAmount.text = arrProductData[indexPath.row].invoice_product_total

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            self.deleteProductData(selectedProduct: self.arrProductData[indexPath.row], index: indexPath.row)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") {  (contextualAction, view, boolValue) in
            
            self.gotoInvoiceAddProductVC(isGST: self.isGST , isUpdate: true, selectedProduct: self.arrProductData[indexPath.row], Invoice_UID: self.arrProductData[indexPath.row].invoice_product_id ?? Date())
        }
        
        editAction.backgroundColor = UIColor.init(hexString: colors.themeBlueColor)
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem , editAction])
        return swipeActions
    }

}
