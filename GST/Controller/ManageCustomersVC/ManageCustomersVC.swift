//
//  ManageCustomersVC.swift
//  GST
//
//  Created by Ketan on 30/01/2022.
//

import UIKit
import CoreData

class ManageCustomersVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tblManageCustomers: UITableView!
    
    // MARK: - Variable Decleration
    var arrCustomerData = [ManageCustomer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchCustomerData()
    }
    
    // MARK: - Private Method
    func setDefault() {
        tblManageCustomers.delegate = self
        tblManageCustomers.dataSource = self
        tblManageCustomers.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func fetchCustomerData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ManageCustomer>(entityName: "ManageCustomer")
        do {
            arrCustomerData = try context.fetch(fetchRequest)
            self.tblManageCustomers.reloadData()
        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }
    
    func deleteCustomerData(selectedProduct : ManageCustomer , index : Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(selectedProduct)
        do {
            try  context.save()
            arrCustomerData.remove(at: index)
            fetchCustomerData()
        } catch {
            let saveError = error as NSError
            print(saveError)
        }
    }
    
    // MARK: - Button Action
    @IBAction func clickToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddNew(_ sender: UIButton) {
        self.gotoAddCustomerVC(isUpdate: false, selectedCustomer: ManageCustomer())
    }

}

extension ManageCustomersVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCustomerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblManageCustomers.dequeueReusableCell(withIdentifier: "ManageCustomersCell", for: indexPath) as? ManageCustomersCell {
            
            cell.lblName.text = arrCustomerData[indexPath.row].customer_name
            cell.lblAddress.text = arrCustomerData[indexPath.row].customer_address
            cell.lblCity.text = "\(arrCustomerData[indexPath.row].customer_city ?? "") , \(arrCustomerData[indexPath.row].customer_state ?? "")"
            cell.lblGST.text = "GST No : \(arrCustomerData[indexPath.row].customer_gst ?? "")"
            cell.lblPAN.text = "PAN No : \(arrCustomerData[indexPath.row].customer_pan ?? "")"

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
            self.deleteCustomerData(selectedProduct: self.arrCustomerData[indexPath.row], index: indexPath.row)
        }
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") {  (contextualAction, view, boolValue) in
            
            self.gotoAddCustomerVC(isUpdate: true, selectedCustomer: self.arrCustomerData[indexPath.row])
        }
        
        editAction.backgroundColor = UIColor.init(hexString: colors.themeBlueColor)
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem , editAction])
        return swipeActions
    }

}
