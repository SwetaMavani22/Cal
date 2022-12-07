//
//  ManageProductsVC.swift
//  GST
//
//  Created by Ketan on 30/01/2022.
//

import UIKit
import CoreData

class ManageProductsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tblManageProducts: UITableView!
    
    // MARK: - Variable Decleration
    var arrProductData = [ManageProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tblManageProducts.reloadData()
        self.fetchProductData()
    }
    
    // MARK: - Private Method
    func setDefault() {
        tblManageProducts.delegate = self
        tblManageProducts.dataSource = self
        tblManageProducts.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func fetchProductData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ManageProduct>(entityName: "ManageProduct")
        do {
            arrProductData = try context.fetch(fetchRequest)
            self.tblManageProducts.reloadData()
        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }
    
    func deleteProductData(selectedProduct : ManageProduct , index : Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(selectedProduct)
        
        do {
            try  context.save()
            arrProductData.remove(at: index)
            fetchProductData()
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
        self.gotoAddProductVC(isUpdate: false, selectedProduct: ManageProduct())
    }

}

extension ManageProductsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProductData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblManageProducts.dequeueReusableCell(withIdentifier: "ManageProductsCell", for: indexPath) as? ManageProductsCell {
            
            cell.lblProductName.text = arrProductData[indexPath.row].product_name
            cell.lblProductHSN.text = "HSN/SAS : \(arrProductData[indexPath.row].product_hsn ?? "")"
            cell.lblProductGST.text = "GST % : \(arrProductData[indexPath.row].product_gst ?? "")"
            cell.lblProductUnit.text = "Unit : \(arrProductData[indexPath.row].product_unit ?? "")"
            cell.lblProductAmount.text = arrProductData[indexPath.row].product_price

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
            
            self.gotoAddProductVC(isUpdate: true, selectedProduct: self.arrProductData[indexPath.row])
        }
        
        editAction.backgroundColor = UIColor.init(hexString: colors.themeBlueColor)
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem , editAction])
        return swipeActions
    }

}
