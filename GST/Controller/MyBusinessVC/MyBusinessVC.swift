//
//  MyBusinessVC.swift
//  GST
//
//  Created by Ketan on 30/01/2022.
//

import UIKit

class MyBusinessVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtInvoiceTitle: AkiraTextField!
    @IBOutlet weak var txtName: AkiraTextField!
    @IBOutlet weak var txtAddress: AkiraTextField!
    @IBOutlet weak var txtEmail: AkiraTextField!
    @IBOutlet weak var txtCity: AkiraTextField!
    @IBOutlet weak var txtState: AkiraTextField!
    @IBOutlet weak var txtZipcode: AkiraTextField!
    @IBOutlet weak var txtPhoneNo: AkiraTextField!
    @IBOutlet weak var txtPANNo: AkiraTextField!
    @IBOutlet weak var txtGSTNo: AkiraTextField!
    @IBOutlet weak var txtBankName: AkiraTextField!
    @IBOutlet weak var txtAccountNo: AkiraTextField!
    @IBOutlet weak var txtIFSCCode: AkiraTextField!
    @IBOutlet weak var txtTermsAndCondition: AkiraTextField!
    @IBOutlet weak var txtDeliveryTerms: AkiraTextField!
    @IBOutlet weak var txtDeliveryNote: AkiraTextField!
    @IBOutlet weak var txtTermsOfPayment: AkiraTextField!
    @IBOutlet weak var txtSupplierReference: AkiraTextField!
    @IBOutlet weak var txtOtherReference: AkiraTextField!
    @IBOutlet weak var txtDispatchDocNo: AkiraTextField!
    @IBOutlet weak var txtDispatchThrough: AkiraTextField!
    @IBOutlet weak var txtDestination: AkiraTextField!
    
    // MARK: - Variable Decleration
    
    let dropDownState = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    // MARK: - Private Method
    func setDefault() {
        
        setupGroupDropDown()
        
        if let data = UserDefaults.standard.data(forKey:  UDKey.kBussinessDetails) {
            do {
                if let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ModelBussinesDetails {
                    self.txtInvoiceTitle.text = data.InvoiceTitle
                    self.txtName.text = data.Name
                    self.txtAddress.text = data.Address
                    self.txtEmail.text = data.Email
                    self.txtCity.text = data.City
                    self.txtState.text = data.State
                    self.txtZipcode.text = data.Zipcode
                    self.txtPhoneNo.text = data.PhoneNo
                    self.txtPANNo.text = data.PanNo
                    self.txtGSTNo.text = data.GstNo
                    self.txtBankName.text = data.BankName
                    self.txtAccountNo.text = data.AccountNo
                    self.txtIFSCCode.text = data.IFSCCode
                    self.txtTermsAndCondition.text = data.TermsAndCondition
                    self.txtDeliveryTerms.text = data.DeliveryTerms
                    self.txtDeliveryNote.text = data.DeliveryNote
                    self.txtTermsOfPayment.text = data.TermsOfPayment
                    self.txtSupplierReference.text = data.SupplierRef
                    self.txtOtherReference.text = data.OtherRef
                    self.txtDispatchDocNo.text = data.DispatchDocNo
                    self.txtDispatchThrough.text = data.DispatchThrough
                    self.txtDestination.text = data.Destination
                }
            } catch {
                print("Something went wrong.")
            }
        }
    }
    
    func saveBussinessInfo() {
        let dict:[String:Any] = ["InvoiceTitle": self.txtInvoiceTitle.text ?? "",
                                 "Name": self.txtName.text ?? "",
                                 "Address": self.txtAddress.text ?? "",
                                 "Email": self.txtEmail.text ?? "",
                                 "City": self.txtCity.text ?? "",
                                 "State": self.txtState.text ?? "",
                                 "Zipcode": self.txtZipcode.text ?? "",
                                 "PhoneNo": self.txtPhoneNo.text ?? "",
                                 "PanNo": self.txtPANNo.text ?? "",
                                 "GstNo": self.txtGSTNo.text ?? "",
                                 "BankName": self.txtBankName.text ?? "",
                                 "AccountNo": self.txtAccountNo.text ?? "",
                                 "IFSCCode": self.txtIFSCCode.text ?? "",
                                 "TermsAndCondition": self.txtTermsAndCondition.text ?? "",
                                 "DeliveryTerms": self.txtDeliveryTerms.text ?? "",
                                 "DeliveryNote": self.txtDeliveryNote.text ?? "",
                                 "TermsOfPayment": self.txtTermsOfPayment.text ?? "",
                                 "SupplierRef": self.txtSupplierReference.text ?? "",
                                 "OtherRef": self.txtOtherReference.text ?? "",
                                 "DispatchDocNo": self.txtDispatchDocNo.text ?? "",
                                 "DispatchThrough": self.txtDispatchThrough.text ?? "",
                                 "Destination": self.txtDestination.text ?? ""]
        
        BussinessDetails = ModelBussinesDetails(dic:dict)
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: BussinessDetails, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: UDKey.kBussinessDetails)
            if let data = UserDefaults.standard.data(forKey:  UDKey.kBussinessDetails) {
                do {
                    if let detail = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ModelBussinesDetails {
                        BussinessDetails = detail
                        self.view.makeToast("Bussiness Information Save.")
                        
                        if (UserDefaults.standard.bool(forKey: UDKey.kFirsttimeopen) == false) {
                            UserDefaults.standard.set(true, forKey: UDKey.kFirsttimeopen)
                            UserDefaults.standard.synchronize()
                            self.gotoHomeVC()
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } catch {
                    print("Something went wrong.")
                }
            }
        }
        catch {
            print("Something went wrong.")
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
        
        if (UserDefaults.standard.bool(forKey: UDKey.kFirsttimeopen) == false) {
            UserDefaults.standard.set(true, forKey: UDKey.kFirsttimeopen)
            UserDefaults.standard.synchronize()
            self.gotoHomeVC()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func clickToSaveMyInfo(_ sender: UIButton) {
        
        if let invoiceTitle = self.txtInvoiceTitle.text, invoiceTitle.isEmpty {
            self.view.makeToast("Please Enter Invoice Title.")
        } else if let name = self.txtName.text, name.isEmpty {
            self.view.makeToast("Please Enter Name.")
        } else if let address = self.txtAddress.text, address.isEmpty {
            self.view.makeToast("Please Enter Address.")
        } else if (txtEmail.text != "" && !isValidEmail(email: self.txtEmail.text ?? "") ){
            self.view.makeToast("Please Enter Valid Email")
        } else if (txtGSTNo.text != "" && !isValidGST(gst: txtGSTNo.text ?? "")){
            self.view.makeToast("Please Enter Valid GST No.")
        }  else if let city = self.txtCity.text, city.isEmpty {
            self.view.makeToast("Please Enter City.")
        } else if let state = self.txtState.text, state.isEmpty {
            self.view.makeToast("Please Enter State.")
        } else {
            self.saveBussinessInfo()
        }
        
        
    }

    @IBAction func clickToState(_ sender: UIButton) {
        
        self.dropDownState.show()
    }

}
