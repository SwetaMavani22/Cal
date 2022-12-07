//
//  UIController+Ext.swift
//  mExpense
//
//  Created by user1 on 26/10/21.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    func gotoHomeVC() {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: HomeVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoCreateInvoiceVC(isUpdate : Bool, selectedInvoiceDate : CreateInvoice , lastCreateInvoice : Date? ,isLastCreateInvoice : Bool ) {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: CreateInvoiceVC.self)
        vc.lastCreateInvoice = lastCreateInvoice ?? Date()
        vc.isLastCreateInvoice = isLastCreateInvoice
        vc.isUpdate = isUpdate
        vc.selectedInvoiceDate = selectedInvoiceDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoInvoiceHistoryVC() {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: InvoiceHistoryVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoManageProductsVC() {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: ManageProductsVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoManageCustomersVC() {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: ManageCustomersVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoAddCustomerVC(isUpdate : Bool , selectedCustomer : ManageCustomer) {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: AddCustomerVC.self)
        vc.isUpdate = isUpdate
        vc.selectedCustomer = selectedCustomer
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoMyBusinessVC() {
        DispatchQueue.main.async {
            let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: MyBusinessVC.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func gotoAppTrans() {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: ViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoBillProductsVC(isGST : Bool , Invoice_UID : Date , isUpdate : Bool , invoiceDetail: NSManagedObject? , selectedInvoiceDate : CreateInvoice , lastCreateInvoice : Date? ,isLastCreateInvoice : Bool ,isStateMatch : Bool) {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: BillProductsVC.self)
        vc.isStateMatch = isStateMatch
        vc.lastCreateInvoice = lastCreateInvoice ?? Date()
        vc.isLastCreateInvoice = isLastCreateInvoice
        vc.isGST = isGST
        vc.Invoice_UID = Invoice_UID
        vc.isUpdate = isUpdate
        vc.invoiceDetail = invoiceDetail
        vc.selectedInvoiceDate = selectedInvoiceDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoAddProductVC(isUpdate : Bool , selectedProduct : ManageProduct) {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: AddProductVC.self)
        vc.isUpdate = isUpdate
        vc.selecteProduct = selectedProduct
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoInvoiceAddProductVC(isGST : Bool , isUpdate : Bool ,selectedProduct : ManageInvoiceProduct , Invoice_UID : Date) {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: InvoiceAddProductVC.self)
        vc.isGST = isGST
        vc.isUpdate = isUpdate
        vc.selectedProduct = selectedProduct
        vc.Invoice_UID = Invoice_UID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoSummaryVC(isGST : Bool, Invoice_UID : Date , subTotal : Double , isUpdate : Bool, invoiceDetail: NSManagedObject?, selectedInvoiceDate : CreateInvoice , lastCreateInvoice : Date? ,isLastCreateInvoice : Bool,isStateMatch : Bool) {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: SummaryVC.self)
        vc.isStateMatch = isStateMatch
        vc.lastCreateInvoice = lastCreateInvoice ?? Date()
        vc.isLastCreateInvoice = isLastCreateInvoice
        vc.isGST = isGST
        vc.Invoice_UID = Invoice_UID
        vc.subTotal = subTotal
        vc.isUpdate = isUpdate
        vc.invoiceDetail = invoiceDetail
        vc.selectedInvoiceDate = selectedInvoiceDate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoSettingsVC() {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: SettingsVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoInvoiceVC(billProductData : [ManageInvoiceProduct] , invoiceData : CreateInvoice) {
        let vc = UIStoryboard.instantiateViewController(storyborad: .main, withViewClass: InvoiceVC.self)
        vc.billProductData = billProductData
        vc.invoiceData = invoiceData
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
