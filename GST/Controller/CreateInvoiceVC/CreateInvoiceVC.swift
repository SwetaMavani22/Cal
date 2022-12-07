//
//  CreateInvoiceVC.swift
//  GST
//
//  Created by ViPrak-Ankit on 28/01/22.
//

import UIKit
import CoreData

class CreateInvoiceVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtInvoiceNo: AkiraTextField!
    @IBOutlet weak var txtDate: AkiraTextField!
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
    @IBOutlet weak var txtDeliveryDate: AkiraTextField!
    @IBOutlet weak var txtReceiverName: AkiraTextField!
    @IBOutlet weak var txtReceiveAddress: AkiraTextField!
    @IBOutlet weak var txtReceiveEmail: AkiraTextField!
    @IBOutlet weak var txtReceiveCity: AkiraTextField!
    @IBOutlet weak var txtReceiveState: AkiraTextField!
    @IBOutlet weak var txtReceiveZipcode: AkiraTextField!
    @IBOutlet weak var txtReceivePhoneNo: AkiraTextField!
    @IBOutlet weak var txtReceivePANNo: AkiraTextField!
    @IBOutlet weak var txtReceiveGSTNo: AkiraTextField!
    @IBOutlet weak var txtEWayBill: AkiraTextField!
    
    @IBOutlet weak var viewDeliveryDate: UIView!

    @IBOutlet weak var imgGST: UIImageView!
    @IBOutlet weak var imgMoreInfo: UIImageView!
    
    @IBOutlet weak var tblCustomer : UITableView!
    
    @IBOutlet weak var btnReciverDropdown : UIButton!

    // MARK: - Variable Decleration
    var pickerPopUp:PickerPopUpVC = PickerPopUpVC()
    var dateFormatter = DateFormatter()
    let dropDownState = DropDown()
    let dropDownReceiverState = DropDown()
    var Invoice_UID = Date()
    var isUpdate = false
    var selectedInvoiceDate = CreateInvoice()
    var lastCreateInvoice = Date()
    var isLastCreateInvoice = false
    var isStateMatch =  false

    var arrCustomerData = [ManageCustomer]()
    var arrFilterCustomerData = [ManageCustomer]()
    var isFromDate = ""

    var invoice = NSManagedObject()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.dropDownState,
            self.dropDownReceiverState
        ]
    }()

    var isGST = false
    var invoice_payment_status = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tblCustomer.isHidden = true
    }
    
    // MARK: - Private Method
    func setDefault() {
        
        tblCustomer.delegate = self
        tblCustomer.dataSource = self
        tblCustomer.estimatedRowHeight = UITableView.automaticDimension

        fetchCustomerData()
        setupGroupDropDown()
        setupGroupReceiverDropDown()
        
        if isUpdate {
            if isLastCreateInvoice {
                lastCreatedInvoice()
            } else {
                updateDataSetup()
            }
        } else {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            txtDate.text = dateFormatter.string(from: Date())

            isGST = true
            imgGST.image = UIImage(systemName: "checkmark.square.fill")
            imgMoreInfo.image = UIImage(systemName: "chevron.up.circle.fill")
            
            if let data = UserDefaults.standard.data(forKey:  UDKey.kBussinessDetails) {
                do {
                    if let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ModelBussinesDetails {
                        
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
    }
    
    func updateDataSetup() {
        
        isGST = selectedInvoiceDate.invoice_isGST
        Invoice_UID = selectedInvoiceDate.invoice_id ?? Date()
        txtAccountNo.text =  selectedInvoiceDate.invoice_accountno
        txtAddress.text =  selectedInvoiceDate.invoice_address
        txtBankName.text =  selectedInvoiceDate.invoice_bankname
        txtCity.text =  selectedInvoiceDate.invoice_city
        txtDate.text =  selectedInvoiceDate.invoice_date
        txtDeliveryDate.text =  selectedInvoiceDate.invoice_deliverydate
        txtDeliveryNote.text =  selectedInvoiceDate.invoice_deliverynote
        txtDeliveryTerms.text =  selectedInvoiceDate.invoice_deliveryterms
        txtDestination.text =  selectedInvoiceDate.invoice_destination
        txtDispatchDocNo.text =  selectedInvoiceDate.invoice_dispatchdocno
        txtDispatchThrough.text =  selectedInvoiceDate.invoice_dispatchthrough
        txtEmail.text =  selectedInvoiceDate.invoice_email
        txtEWayBill.text =  selectedInvoiceDate.invoice_eway
        txtGSTNo.text =  selectedInvoiceDate.invoice_gst
        txtIFSCCode.text =  selectedInvoiceDate.invoice_ifsc
        txtName.text =  selectedInvoiceDate.invoice_name
        txtInvoiceNo.text =  selectedInvoiceDate.invoice_no
        txtOtherReference.text =  selectedInvoiceDate.invoice_other
        txtPANNo.text =  selectedInvoiceDate.invoice_pan
        txtPhoneNo.text =  selectedInvoiceDate.invoice_phone
        txtReceiveAddress.text =  selectedInvoiceDate.invoice_receiver_address
        txtReceiveCity.text =  selectedInvoiceDate.invoice_receiver_city
        txtReceiveEmail.text =  selectedInvoiceDate.invoice_receiver_email
        txtReceiveGSTNo.text =  selectedInvoiceDate.invoice_receiver_gst
        txtReceiverName.text =  selectedInvoiceDate.invoice_receiver_name
        txtReceivePANNo.text =  selectedInvoiceDate.invoice_receiver_pan
        txtReceivePhoneNo.text =  selectedInvoiceDate.invoice_receiver_phone
        txtReceiveState.text =  selectedInvoiceDate.invoice_receiver_state
        txtReceiveZipcode.text =  selectedInvoiceDate.invoice_receiver_zipcode
        txtState.text =  selectedInvoiceDate.invoice_state
        txtSupplierReference.text =  selectedInvoiceDate.invoice_supplier
        txtTermsAndCondition.text =  selectedInvoiceDate.invoice_termsandcondition
        txtTermsOfPayment.text =  selectedInvoiceDate.invoice_termsofpayment
        txtZipcode.text =  selectedInvoiceDate.invoice_zipcode
        invoice_payment_status =  selectedInvoiceDate.invoice_payment_status

        self.imgGST.image = (selectedInvoiceDate.invoice_isGST) ? UIImage.init(systemName: "checkmark.square.fill") : UIImage.init(systemName: "square")

    }
         
    func lastCreatedInvoice() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CreateInvoice>(entityName: "CreateInvoice")
        fetchRequest.predicate = NSPredicate(format: "invoice_id = %@", lastCreateInvoice as CVarArg )
        do
        {
            let value = try  context.fetch(fetchRequest)
            let product = value[0] as NSManagedObject
            
            isGST = product.value(forKey: "invoice_isGST") as? Bool ?? false
            Invoice_UID = lastCreateInvoice
            txtAccountNo.text =  product.value(forKey: "invoice_accountno") as? String ?? ""
            txtAddress.text =  product.value(forKey: "invoice_address") as? String ?? ""
            txtBankName.text =  product.value(forKey: "invoice_bankname") as? String ?? ""
            txtCity.text =  product.value(forKey: "invoice_city") as? String ?? ""
            txtDate.text =  product.value(forKey: "invoice_date") as? String ?? ""
            txtDeliveryDate.text =  product.value(forKey: "invoice_deliverydate") as? String ?? ""
            txtDeliveryNote.text =  product.value(forKey: "invoice_deliverynote") as? String ?? ""
            txtDeliveryTerms.text =  product.value(forKey: "invoice_deliveryterms") as? String ?? ""
            txtDestination.text =  product.value(forKey: "invoice_destination") as? String ?? ""
            txtDispatchDocNo.text =  product.value(forKey: "invoice_dispatchdocno") as? String ?? ""
            txtDispatchThrough.text =  product.value(forKey: "invoice_dispatchthrough") as? String ?? ""
            txtEmail.text =  product.value(forKey: "invoice_email") as? String ?? ""
            txtEWayBill.text =  product.value(forKey: "invoice_eway") as? String ?? ""
            txtGSTNo.text =  product.value(forKey: "invoice_gst") as? String ?? ""
            txtIFSCCode.text =  product.value(forKey: "invoice_ifsc") as? String ?? ""
            txtName.text =  product.value(forKey: "invoice_name") as? String ?? ""
            txtInvoiceNo.text =  product.value(forKey: "invoice_no") as? String ?? ""
            txtOtherReference.text =  product.value(forKey: "invoice_other") as? String ?? ""
            txtPANNo.text =  product.value(forKey: "invoice_pan") as? String ?? ""
            txtPhoneNo.text =  product.value(forKey: "invoice_phone") as? String ?? ""
            txtReceiveAddress.text =  product.value(forKey: "invoice_receiver_address") as? String ?? ""
            txtReceiveCity.text =  product.value(forKey: "invoice_receiver_city") as? String ?? ""
            txtReceiveEmail.text =  product.value(forKey: "invoice_receiver_email") as? String ?? ""
            txtReceiveGSTNo.text =  product.value(forKey: "invoice_receiver_gst") as? String ?? ""
            txtReceiverName.text =  product.value(forKey: "invoice_receiver_name") as? String ?? ""
            txtReceivePANNo.text =  product.value(forKey: "invoice_receiver_pan") as? String ?? ""
            txtReceivePhoneNo.text =  product.value(forKey: "invoice_receiver_phone") as? String ?? ""
            txtReceiveState.text =  product.value(forKey: "invoice_receiver_state") as? String ?? ""
            txtReceiveZipcode.text =  product.value(forKey: "invoice_receiver_zipcode") as? String ?? ""
            txtState.text = product.value(forKey: "invoice_state") as? String ?? ""
            txtSupplierReference.text = product.value(forKey: "invoice_supplier") as? String ?? ""
            txtTermsAndCondition.text = product.value(forKey: "invoice_termsandcondition") as? String ?? ""
            txtTermsOfPayment.text =  product.value(forKey: "invoice_termsofpayment") as? String ?? ""
            txtZipcode.text =  product.value(forKey: "invoice_zipcode") as? String ?? ""
            invoice_payment_status =  product.value(forKey: "invoice_payment_status") as? Bool ?? false

            self.imgGST.image = (isGST) ? UIImage.init(systemName: "checkmark.square.fill") : UIImage.init(systemName: "square")

        }catch{
            print(error)
            self.view.makeToast("Product Not Update.")
        }
    }
    
    func HideMoreInfoView(isHide : Bool) {
        
        txtDeliveryNote.isHidden = isHide
        txtTermsOfPayment.isHidden = isHide
        txtSupplierReference.isHidden = isHide
        txtOtherReference.isHidden = isHide
        txtDispatchDocNo.isHidden = isHide
        viewDeliveryDate.isHidden = isHide
        txtDispatchThrough.isHidden = isHide
        txtDestination.isHidden = isHide
        txtDeliveryTerms.isHidden = isHide
    }
    
    func setupGroupDropDown() {
        
        dropDownState.anchorView = txtState
        dropDownState.bottomOffset = CGPoint(x: 0, y: txtState.bounds.height)
        dropDownState.dataSource = arrState

        dropDownState.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtState.text = item
        }
    }
    
    func setupGroupReceiverDropDown() {
        
        dropDownReceiverState.anchorView = txtReceiveState
        dropDownReceiverState.bottomOffset = CGPoint(x: 0, y: txtReceiveState.bounds.height)
        dropDownReceiverState.dataSource = arrState

        dropDownReceiverState.selectionAction = { [unowned self] (index: Int, item: String) in
            self.txtReceiveState.text = item
        }
    }

    func AddInvoiceDetails() {

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CreateInvoice",in: context)!
        self.invoice = NSManagedObject(entity: entity,insertInto: context)
        
        invoice.setValue(isGST, forKey: "invoice_isGST")
        invoice.setValue(Invoice_UID, forKey: "invoice_id")
        invoice.setValue(txtAccountNo.text, forKey: "invoice_accountno")
        invoice.setValue(txtAddress.text, forKey: "invoice_address")
        invoice.setValue(txtBankName.text, forKey: "invoice_bankname")
        invoice.setValue(txtCity.text, forKey: "invoice_city")
        invoice.setValue(txtDate.text, forKey: "invoice_date")
        invoice.setValue(txtDeliveryDate.text, forKey: "invoice_deliverydate")
        invoice.setValue(txtDeliveryNote.text, forKey: "invoice_deliverynote")
        invoice.setValue(txtDeliveryTerms.text, forKey: "invoice_deliveryterms")
        invoice.setValue(txtDestination.text, forKey: "invoice_destination")
        invoice.setValue(txtDispatchDocNo.text, forKey: "invoice_dispatchdocno")
        invoice.setValue(txtDispatchThrough.text, forKey: "invoice_dispatchthrough")
        invoice.setValue(txtEmail.text, forKey: "invoice_email")
        invoice.setValue(txtEWayBill.text, forKey: "invoice_eway")
        invoice.setValue(txtGSTNo.text, forKey: "invoice_gst")
        invoice.setValue(txtIFSCCode.text, forKey: "invoice_ifsc")
        invoice.setValue(txtName.text, forKey: "invoice_name")
        invoice.setValue(txtInvoiceNo.text, forKey: "invoice_no")
        invoice.setValue(txtOtherReference.text, forKey: "invoice_other")
        invoice.setValue(txtPANNo.text, forKey: "invoice_pan")
        invoice.setValue(txtPhoneNo.text, forKey: "invoice_phone")
        invoice.setValue(txtReceiveAddress.text, forKey: "invoice_receiver_address")
        invoice.setValue(txtReceiveCity.text, forKey: "invoice_receiver_city")
        invoice.setValue(txtReceiveEmail.text, forKey: "invoice_receiver_email")
        invoice.setValue(txtReceiveGSTNo.text, forKey: "invoice_receiver_gst")
        invoice.setValue(txtReceiverName.text, forKey: "invoice_receiver_name")
        invoice.setValue(txtReceivePANNo.text, forKey: "invoice_receiver_pan")
        invoice.setValue(txtReceivePhoneNo.text, forKey: "invoice_receiver_phone")
        invoice.setValue(txtReceiveState.text, forKey: "invoice_receiver_state")
        invoice.setValue(txtReceiveZipcode.text, forKey: "invoice_receiver_zipcode")
        invoice.setValue(txtState.text, forKey: "invoice_state")
        invoice.setValue(txtSupplierReference.text, forKey: "invoice_supplier")
        invoice.setValue(txtTermsAndCondition.text, forKey: "invoice_termsandcondition")
        invoice.setValue(txtTermsOfPayment.text, forKey: "invoice_termsofpayment")
        invoice.setValue(txtZipcode.text, forKey: "invoice_zipcode")
        invoice.setValue(false, forKey: "invoice_payment_status")
        
        if txtState.text == txtReceiveState.text {
            isStateMatch = true
        } else {
            isStateMatch = false
        }
        
        self.gotoBillProductsVC(isGST: self.isGST, Invoice_UID: self.Invoice_UID, isUpdate: self.isUpdate, invoiceDetail: invoice, selectedInvoiceDate: self.selectedInvoiceDate , lastCreateInvoice: self.lastCreateInvoice , isLastCreateInvoice : self.isLastCreateInvoice, isStateMatch: self.isStateMatch)
    }

    func UpdateInvoice(invoice_ID : Date) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<CreateInvoice>(entityName: "CreateInvoice")
        fetchRequest.predicate = NSPredicate(format: "invoice_id = %@", invoice_ID as CVarArg )
        do
        {
            let value = try  context.fetch(fetchRequest)
            let invoice = value[0] as NSManagedObject
            invoice.setValue(isGST, forKey: "invoice_isGST")
            invoice.setValue(invoice_ID, forKey: "invoice_id")
            invoice.setValue(txtAccountNo.text, forKey: "invoice_accountno")
            invoice.setValue(txtAddress.text, forKey: "invoice_address")
            invoice.setValue(txtBankName.text, forKey: "invoice_bankname")
            invoice.setValue(txtCity.text, forKey: "invoice_city")
            invoice.setValue(txtDate.text, forKey: "invoice_date")
            invoice.setValue(txtDeliveryDate.text, forKey: "invoice_deliverydate")
            invoice.setValue(txtDeliveryNote.text, forKey: "invoice_deliverynote")
            invoice.setValue(txtDeliveryTerms.text, forKey: "invoice_deliveryterms")
            invoice.setValue(txtDestination.text, forKey: "invoice_destination")
            invoice.setValue(txtDispatchDocNo.text, forKey: "invoice_dispatchdocno")
            invoice.setValue(txtDispatchThrough.text, forKey: "invoice_dispatchthrough")
            invoice.setValue(txtEmail.text, forKey: "invoice_email")
            invoice.setValue(txtEWayBill.text, forKey: "invoice_eway")
            invoice.setValue(txtGSTNo.text, forKey: "invoice_gst")
            invoice.setValue(txtIFSCCode.text, forKey: "invoice_ifsc")
            invoice.setValue(txtName.text, forKey: "invoice_name")
            invoice.setValue(txtInvoiceNo.text, forKey: "invoice_no")
            invoice.setValue(txtOtherReference.text, forKey: "invoice_other")
            invoice.setValue(txtPANNo.text, forKey: "invoice_pan")
            invoice.setValue(txtPhoneNo.text, forKey: "invoice_phone")
            invoice.setValue(txtReceiveAddress.text, forKey: "invoice_receiver_address")
            invoice.setValue(txtReceiveCity.text, forKey: "invoice_receiver_city")
            invoice.setValue(txtReceiveEmail.text, forKey: "invoice_receiver_email")
            invoice.setValue(txtReceiveGSTNo.text, forKey: "invoice_receiver_gst")
            invoice.setValue(txtReceiverName.text, forKey: "invoice_receiver_name")
            invoice.setValue(txtReceivePANNo.text, forKey: "invoice_receiver_pan")
            invoice.setValue(txtReceivePhoneNo.text, forKey: "invoice_receiver_phone")
            invoice.setValue(txtReceiveState.text, forKey: "invoice_receiver_state")
            invoice.setValue(txtReceiveZipcode.text, forKey: "invoice_receiver_zipcode")
            invoice.setValue(txtState.text, forKey: "invoice_state")
            invoice.setValue(txtSupplierReference.text, forKey: "invoice_supplier")
            invoice.setValue(txtTermsAndCondition.text, forKey: "invoice_termsandcondition")
            invoice.setValue(txtTermsOfPayment.text, forKey: "invoice_termsofpayment")
            invoice.setValue(txtZipcode.text, forKey: "invoice_zipcode")
            invoice.setValue(invoice_payment_status, forKey: "invoice_payment_status")
            
            if txtState.text == txtReceiveState.text {
                isStateMatch = true
            } else {
                isStateMatch = false
            }

            self.gotoBillProductsVC(isGST: self.isGST, Invoice_UID: self.Invoice_UID, isUpdate: self.isUpdate, invoiceDetail: invoice, selectedInvoiceDate: self.selectedInvoiceDate, lastCreateInvoice: self.lastCreateInvoice , isLastCreateInvoice : self.isLastCreateInvoice, isStateMatch: self.isStateMatch)

        }catch{
            print(error)
            self.view.makeToast("Product Not Update.")
        }
    }

    func fetchCustomerData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ManageCustomer>(entityName: "ManageCustomer")
        do {
            arrCustomerData = try context.fetch(fetchRequest)
            arrFilterCustomerData = arrCustomerData
            self.tblCustomer.reloadData()
        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }

    func animate(toogle: Bool, type: UIButton) {
        
        if type == btnReciverDropdown {
            if toogle {
                UIView.animate(withDuration: 0.3) {
                    self.tblCustomer.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.tblCustomer.isHidden = true
                }
            }
        }
    }

    // MARK: - Button Action
    @IBAction func clickToBack(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.invoice)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToAddProduct(_ sender: UIButton) {
        
        if let invoiceTitle = self.txtInvoiceNo.text, invoiceTitle.isEmpty {
            self.view.makeToast("Please Enter Invoice Title.")
        } else if let date = self.txtDate.text, date.isEmpty {
            self.view.makeToast("Please Enter Date.")
        } else if let name = self.txtName.text, name.isEmpty {
            self.view.makeToast("Please Enter Name.")
        } else if let address = self.txtAddress.text, address.isEmpty {
            self.view.makeToast("Please Enter Address.")
        } else if (txtEmail.text != "" && !isValidEmail(email: self.txtEmail.text ?? "") ){
            self.view.makeToast("Please Enter Valid Email.")
        } else if let city = self.txtCity.text, city.isEmpty {
            self.view.makeToast("Please Enter City.")
        } else if let state = self.txtState.text, state.isEmpty {
            self.view.makeToast("Please Enter State.")
        } else if let Receivername = self.txtReceiverName.text, Receivername.isEmpty {
            self.view.makeToast("Please Enter Receiver Name.")
        } else if let Receiveraddress = self.txtReceiveAddress.text, Receiveraddress.isEmpty {
            self.view.makeToast("Please Enter Receiver Address.")
        } else if (txtReceiveEmail.text != "" && !isValidEmail(email: self.txtReceiveEmail.text ?? "") ){
            self.view.makeToast("Please Enter Valid Receiver Email.")
        } else if let Receivercity = self.txtReceiveCity.text, Receivercity.isEmpty {
            self.view.makeToast("Please Enter Receiver City.")
        } else if let Receiverstate = self.txtReceiveState.text, Receiverstate.isEmpty {
            self.view.makeToast("Please Enter Receiver State.")
        } else if imgGST.image == UIImage(systemName: "checkmark.square.fill"), let gst = self.txtGSTNo.text, gst.isEmpty ,!isValidGST(gst: txtGSTNo.text ?? "") {
            self.view.makeToast("Please Enter GST No.")
        } else if imgGST.image == UIImage(systemName: "checkmark.square.fill"), let gst = self.txtReceiveGSTNo.text, gst.isEmpty ,!isValidGST(gst: txtReceiveGSTNo.text ?? "") {
            self.view.makeToast("Please Enter Receiver GST No.")
        }else {
            if (isUpdate) {
                UpdateInvoice(invoice_ID: self.Invoice_UID)
            } else {
                AddInvoiceDetails()
            }
            
        }
    }

    @IBAction func clickToHideMoreDetails(_ sender: UIButton) {
        
        if imgMoreInfo.image == UIImage(systemName: "chevron.up.circle.fill") {
            HideMoreInfoView(isHide: true)
            imgMoreInfo.image = UIImage(systemName: "chevron.down.circle.fill")
        } else {
            HideMoreInfoView(isHide: false)
            imgMoreInfo.image = UIImage(systemName: "chevron.up.circle.fill")
        }
    }

    @IBAction func clickToGST(_ sender: UIButton) {
        
        if imgGST.image == UIImage(systemName: "checkmark.square.fill") {
            imgGST.image = UIImage(systemName: "square")
            isGST = false
        } else {
            imgGST.image = UIImage(systemName: "checkmark.square.fill")
            isGST = true
        }
    }

    @IBAction func clickToDate(_ sender: UIButton) {
        
        self.view.endEditing(true)
        isFromDate = "clickToDate"
        self.openPickerPopUp()
    }
    
    @IBAction func clickToDeliveryDate(_ sender: UIButton) {
        
        self.view.endEditing(true)
        isFromDate = "clickToDeliveryDate"
        self.openPickerPopUp()
    }

    @IBAction func clickToState(_ sender: UIButton) {
        
        self.dropDownState.show()
    }
    
    @IBAction func clickToReceiverState(_ sender: UIButton) {
        
        self.dropDownReceiverState.show()
    }

    @IBAction func clickToReciverDropDown(_ sender: UIButton) {
        
        if tblCustomer.isHidden {
            btnReciverDropdown.setImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
            animate(toogle: true, type: btnReciverDropdown)
        } else {
            btnReciverDropdown.setImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
            animate(toogle: false, type: btnReciverDropdown)
        }
    }
}

extension CreateInvoiceVC: UIPickerViewDelegate  {
    
    func openPickerPopUp() {
        pickerPopUp = Bundle.main.loadNibNamed("PickerPopUpVC", owner: self, options: nil)?[0] as! PickerPopUpVC
        pickerPopUp.frame = self.view.frame
        pickerPopUp.btn_Cancel.addTarget(self, action: #selector(cancelPickerPopUp), for: .touchUpInside)
        pickerPopUp.btn_Done.addTarget(self, action: #selector(donePickerPopUp), for: .touchUpInside)
        self.view.addSubview(pickerPopUp)
    }
    
    @objc func cancelPickerPopUp() {
        pickerPopUp.closeAnimation()
    }
    
    @objc func donePickerPopUp() {
        
        print("SelectedDate : \(pickerPopUp.picker.date)")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        if isFromDate == "clickToDate" {
            txtDate.text = dateFormatter.string(from: pickerPopUp.picker.date)
        } else {
            txtDeliveryDate.text = dateFormatter.string(from: pickerPopUp.picker.date)
        }
        pickerPopUp.closeAnimation()
    }
}

extension CreateInvoiceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCustomerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblCustomer.dequeueReusableCell(withIdentifier: "ManageCustomersCell", for: indexPath) as? ManageCustomersCell {
            
            cell.lblName.text = arrCustomerData[indexPath.row].customer_name
            cell.lblAddress.text = arrCustomerData[indexPath.row].customer_address
            cell.lblCity.text = "\(arrCustomerData[indexPath.row].customer_city ?? "") , \(arrCustomerData[indexPath.row].customer_state ?? "")"

            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        txtReceiveAddress.text =  arrCustomerData[indexPath.row].customer_address
        txtReceiveCity.text =  arrCustomerData[indexPath.row].customer_city
        txtReceiveEmail.text =  arrCustomerData[indexPath.row].customer_email
        txtReceiveGSTNo.text =  arrCustomerData[indexPath.row].customer_gst
        txtReceiverName.text =  arrCustomerData[indexPath.row].customer_name
        txtReceivePANNo.text =  arrCustomerData[indexPath.row].customer_pan
        txtReceivePhoneNo.text =  arrCustomerData[indexPath.row].customer_phone
        txtReceiveState.text =  arrCustomerData[indexPath.row].customer_state
        txtReceiveZipcode.text =  arrCustomerData[indexPath.row].customer_zipcode

        btnReciverDropdown.setImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        animate(toogle: false, type: btnReciverDropdown)
    }
}

extension CreateInvoiceVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = txtReceiverName.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            
            if (updatedText.isEmpty) {
                txtReceiveAddress.text =  ""
                txtReceiveCity.text =  ""
                txtReceiveEmail.text =  ""
                txtReceiveGSTNo.text =  ""
                txtReceivePANNo.text =  ""
                txtReceivePhoneNo.text =  ""
                txtReceiveState.text =  ""
                txtReceiveZipcode.text =  ""
                arrCustomerData = arrFilterCustomerData
                tblCustomer.isHidden = true
                animate(toogle: false, type: btnReciverDropdown)
            } else {
                arrCustomerData = arrFilterCustomerData.filter { $0.customer_name?.lowercased().range(of: updatedText.lowercased()) != nil
                }
                if arrCustomerData.count > 0 {
                    tblCustomer.isHidden = false
                    animate(toogle: true, type: btnReciverDropdown)
                } else {
                    tblCustomer.isHidden = true
                    animate(toogle: false, type: btnReciverDropdown)
                }
            }
        } else {
            tblCustomer.isHidden = true
            animate(toogle: false, type: btnReciverDropdown)
            arrCustomerData = arrFilterCustomerData
        }
        self.tblCustomer.reloadData()
        return true
    }
}
