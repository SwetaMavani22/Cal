//
//  AddCustomerVC.swift
//  GST
//
//  Created by ViPrak-Ankit on 31/01/22.
//

import UIKit
import CoreData

class AddCustomerVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtName: AkiraTextField!
    @IBOutlet weak var txtAddress: AkiraTextField!
    @IBOutlet weak var txtEmail: AkiraTextField!
    @IBOutlet weak var txtCity: AkiraTextField!
    @IBOutlet weak var txtState: AkiraTextField!
    @IBOutlet weak var txtZipcode: AkiraTextField!
    @IBOutlet weak var txtPhoneNo: AkiraTextField!
    @IBOutlet weak var txtPANNo: AkiraTextField!
    @IBOutlet weak var txtGSTNo: AkiraTextField!
    
    
    // MARK: - Variable Decleration
    var isUpdate = false
    var selectedCustomer = ManageCustomer()
    let dropDownState = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isUpdate {
            
            txtName.text = selectedCustomer.customer_name
            txtAddress.text = selectedCustomer.customer_address
            txtEmail.text = selectedCustomer.customer_email
            txtCity.text = selectedCustomer.customer_city
            txtState.text = selectedCustomer.customer_state
            txtZipcode.text = selectedCustomer.customer_zipcode
            txtPhoneNo.text = selectedCustomer.customer_phone
            txtPANNo.text = selectedCustomer.customer_pan
            txtGSTNo.text = selectedCustomer.customer_gst
        }
    }
    // MARK: - Private Method
    func setDefault() {
        
        setupGroupDropDown()
    }
    
    func AddCustomer() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ManageCustomer",in: context)!
        let customer = NSManagedObject(entity: entity,insertInto: context)
        
        customer.setValue(Date(), forKey: "customer_id")
        customer.setValue(txtName.text, forKey: "customer_name")
        customer.setValue(txtAddress.text, forKey: "customer_address")
        customer.setValue(txtEmail.text, forKey: "customer_email")
        customer.setValue(txtCity.text, forKey: "customer_city")
        customer.setValue(txtState.text, forKey: "customer_state")
        customer.setValue(txtZipcode.text, forKey: "customer_zipcode")
        customer.setValue(txtPhoneNo.text, forKey: "customer_phone")
        customer.setValue(txtPANNo.text, forKey: "customer_pan")
        customer.setValue(txtGSTNo.text, forKey: "customer_gst")

        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func UpdateCustomer() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ManageCustomer>(entityName: "ManageCustomer")
        fetchRequest.predicate = NSPredicate(format: "customer_id = %@", selectedCustomer.customer_id! as CVarArg )
        do
        {
            let value = try  context.fetch(fetchRequest)
            let customer = value[0] as NSManagedObject
            customer.setValue(selectedCustomer.customer_id, forKey: "customer_id")
            customer.setValue(txtName.text, forKey: "customer_name")
            customer.setValue(txtAddress.text, forKey: "customer_address")
            customer.setValue(txtEmail.text, forKey: "customer_email")
            customer.setValue(txtCity.text, forKey: "customer_city")
            customer.setValue(txtState.text, forKey: "customer_state")
            customer.setValue(txtZipcode.text, forKey: "customer_zipcode")
            customer.setValue(txtPhoneNo.text, forKey: "customer_phone")
            customer.setValue(txtPANNo.text, forKey: "customer_pan")
            customer.setValue(txtGSTNo.text, forKey: "customer_gst")

            do{
                try context.save()
                self.navigationController?.popViewController(animated: true)
            }catch{
                print(error)
                self.view.makeToast("Product Not Update.")
            }
        }catch{
            print(error)
            self.view.makeToast("Product Not Update.")
        }
    }
    
    func setupGroupDropDown() {
        
        dropDownState.anchorView = txtState
        dropDownState.bottomOffset = CGPoint(x: 0, y: txtState.bounds.height)
        dropDownState.dataSource = arrState

        dropDownState.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtState.text = item
        }
    }
    
    // MARK: - Button Action
    @IBAction func clickToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAdd(_ sender: UIButton) {
        
        if let name = self.txtName.text, name.isEmpty {
            self.view.makeToast("Please Enter Name.")
        } else if let address = self.txtAddress.text, address.isEmpty {
            self.view.makeToast("Please Enter Address.")
        } else if (txtEmail.text != "" && !isValidEmail(email: self.txtEmail.text ?? "") ){
            self.view.makeToast("Please Enter Valid Email.")
        } else if let city = self.txtCity.text, city.isEmpty {
            self.view.makeToast("Please Enter City.")
        } else if let state = self.txtState.text, state.isEmpty {
            self.view.makeToast("Please Enter State.")
        } else if (txtGSTNo.text != "" && !isValidGST(gst: txtGSTNo.text ?? "")){
            self.view.makeToast("Please Enter Valid GST No.")
        } else {
            if isUpdate {
                self.UpdateCustomer()
            } else {
                self.AddCustomer()
            }
        }
    }

    @IBAction func clickToState(_ sender: UIButton) {
        
        self.dropDownState.show()
    }
}
