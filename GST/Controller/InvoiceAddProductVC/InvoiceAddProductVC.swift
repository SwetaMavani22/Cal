//
//  InvoiceAddProductVC.swift
//  GST
//
//  Created by Mavani on 01/02/22.
//

import UIKit
import CoreData

class InvoiceAddProductVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtProductName: AkiraTextField!
    @IBOutlet weak var txtHSNORSAC: AkiraTextField!
    @IBOutlet weak var txtQuantity: AkiraTextField!
    @IBOutlet weak var txtGST: AkiraTextField!
    @IBOutlet weak var txtPrice: AkiraTextField!
    @IBOutlet weak var txtSizeInch_1: AkiraTextField!
    @IBOutlet weak var txtSizeInch_2: AkiraTextField!
    @IBOutlet weak var txtTotal: AkiraTextField!
    
    @IBOutlet weak var lblQuantity: UILabel!
    
    @IBOutlet weak var imgPcs: UIImageView!
    @IBOutlet weak var imgSquareFeet: UIImageView!
    @IBOutlet weak var imgKG: UIImageView!
    @IBOutlet weak var imgFixed: UIImageView!
    @IBOutlet weak var imgRunningFeet: UIImageView!
    @IBOutlet weak var imgDays: UIImageView!
    
    @IBOutlet weak var tblProduct : UITableView!
    @IBOutlet weak var tblProductHSN : UITableView!
    
    @IBOutlet weak var btnProductDropdown : UIButton!
    @IBOutlet weak var btnProductHSNDropdown : UIButton!
    
    @IBOutlet weak var viewGST : UIView!
    @IBOutlet weak var viewFeetHeight : UIView!

    // MARK: - Variable Decleration
    
    var isUpdate = false
    var selectedProduct = ManageInvoiceProduct()
    var selectedUnit = ""
    var isGST = false
    var Invoice_UID = Date()
    var arrProductData = [ManageProduct]()
    var arrFilterProductData = [ManageProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tblProduct.isHidden = true
        tblProductHSN.isHidden = true
        viewGST.isHidden = true
        viewFeetHeight.isHidden = true

        if isUpdate {
            
            txtProductName.text = selectedProduct.invoice_product_name
            txtGST.text = selectedProduct.invoice_product_gst
            txtHSNORSAC.text = selectedProduct.invoice_product_hsn
            txtPrice.text = selectedProduct.invoice_product_price
            selectedUnit = selectedProduct.invoice_product_unit ?? ""
            txtSizeInch_1.text = selectedProduct.invoice_product_inch_1
            txtSizeInch_2.text = selectedProduct.invoice_product_inch_2
            txtQuantity.text = selectedProduct.invoice_product_quantity
            txtTotal.text = selectedProduct.invoice_product_total
            //isGST = selectedProduct.invoice_product_isGST
            
            if selectedUnit == "Pcs" {
                self.imgPcs.image = UIImage.init(systemName: "record.circle")
                lblQuantity.text = "Pcs"
                viewFeetHeight.isHidden = true
            } else if selectedUnit == "sqft" {
                self.imgSquareFeet.image = UIImage.init(systemName: "record.circle")
                lblQuantity.text = "sqft"
                viewFeetHeight.isHidden = false
            } else if selectedUnit == "KG" {
                self.imgKG.image = UIImage.init(systemName: "record.circle")
                lblQuantity.text = "KG"
                viewFeetHeight.isHidden = true
            } else if selectedUnit == "Fixed" {
                self.imgFixed.image = UIImage.init(systemName: "record.circle")
                lblQuantity.text = "Fixed"
                viewFeetHeight.isHidden = true
            } else if selectedUnit == "RunningFeet" {
                self.imgRunningFeet.image = UIImage.init(systemName: "record.circle")
                lblQuantity.text = "RunningFeet"
                viewFeetHeight.isHidden = true
            } else if selectedUnit == "Days" {
                self.imgDays.image = UIImage.init(systemName: "record.circle")
                lblQuantity.text = "Days"
                viewFeetHeight.isHidden = true
            }
        } else {
            self.imgPcs.image = UIImage.init(systemName: "record.circle")
            lblQuantity.text = "Pcs"
            selectedUnit = "Pcs"
            viewFeetHeight.isHidden = true
        }
        
        if isGST {
            viewGST.isHidden = false
        } else {
            viewGST.isHidden = true
        }
    }
    
    // MARK: - Private Method
    func setDefault() {
        
        tblProduct.delegate = self
        tblProduct.dataSource = self
        tblProduct.estimatedRowHeight = UITableView.automaticDimension
        
        tblProductHSN.delegate = self
        tblProductHSN.dataSource = self
        tblProductHSN.estimatedRowHeight = UITableView.automaticDimension

        fetchProductData()
    }
    
    func AddProduct() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ManageInvoiceProduct",in: context)!
        let product = NSManagedObject(entity: entity,insertInto: context)
        
        product.setValue(Date(), forKey: "product_id")
        product.setValue(txtProductName.text, forKey: "invoice_product_name")
        product.setValue(txtGST.text, forKey: "invoice_product_gst")
        product.setValue(txtHSNORSAC.text, forKey: "invoice_product_hsn")
        product.setValue(txtPrice.text, forKey: "invoice_product_price")
        product.setValue(Invoice_UID, forKey: "invoice_product_id")
        product.setValue(selectedUnit, forKey: "invoice_product_unit")
        product.setValue(txtSizeInch_1.text, forKey: "invoice_product_inch_1")
        product.setValue(txtSizeInch_2.text, forKey: "invoice_product_inch_2")
        product.setValue(txtQuantity.text, forKey: "invoice_product_quantity")
        product.setValue(txtTotal.text, forKey: "invoice_product_total")
        product.setValue(isGST, forKey: "invoice_product_isGST")
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func UpdateProduct() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<ManageInvoiceProduct>(entityName: "ManageInvoiceProduct")
        fetchRequest.predicate = NSPredicate(format: "product_id = %@", selectedProduct.product_id! as CVarArg )
        do
        {
            let value = try  context.fetch(fetchRequest)
            let product = value[0] as NSManagedObject
            
            product.setValue(selectedProduct.product_id, forKey: "product_id")
            product.setValue(txtProductName.text, forKey: "invoice_product_name")
            product.setValue(txtGST.text, forKey: "invoice_product_gst")
            product.setValue(txtHSNORSAC.text, forKey: "invoice_product_hsn")
            product.setValue(txtPrice.text, forKey: "invoice_product_price")
            product.setValue(selectedProduct.invoice_product_id, forKey: "invoice_product_id")
            product.setValue(selectedUnit, forKey: "invoice_product_unit")
            product.setValue(txtSizeInch_1.text, forKey: "invoice_product_inch_1")
            product.setValue(txtSizeInch_2.text, forKey: "invoice_product_inch_2")
            product.setValue(txtQuantity.text, forKey: "invoice_product_quantity")
            product.setValue(txtTotal.text, forKey: "invoice_product_total")
            product.setValue(isGST, forKey: "invoice_product_isGST")
            
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
    
    func fetchProductData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ManageProduct>(entityName: "ManageProduct")
        do {
            arrProductData = try context.fetch(fetchRequest)
            arrFilterProductData = arrProductData
            self.tblProduct.reloadData()
        } catch {
            self.view.makeToast("No Product Found.")
            print("Cannot fetch")
        }
    }
    
    func animate(toogle: Bool, type: UIButton) {
        
        if type == btnProductDropdown {
            if toogle {
                UIView.animate(withDuration: 0.3) {
                    self.tblProduct.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.tblProduct.isHidden = true
                }
            }
        }
    }
    
    func animateHSN(toogle: Bool, type: UIButton) {
        
        if type == btnProductHSNDropdown {
            if toogle {
                UIView.animate(withDuration: 0.3) {
                    self.tblProductHSN.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.tblProductHSN.isHidden = true
                }
            }
        }
    }

    // MARK: - Button Action
    @IBAction func clickToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToUnit(_ sender: UIButton) {
        
        self.imgPcs.image = (sender.tag == 1) ? UIImage.init(systemName: "record.circle") : UIImage.init(systemName: "circle")
        self.imgSquareFeet.image = (sender.tag == 2) ? UIImage.init(systemName: "record.circle") : UIImage.init(systemName: "circle")
        self.imgKG.image = (sender.tag == 3) ? UIImage.init(systemName: "record.circle") : UIImage.init(systemName: "circle")
        self.imgFixed.image = (sender.tag == 4) ? UIImage.init(systemName: "record.circle") : UIImage.init(systemName: "circle")
        self.imgRunningFeet.image = (sender.tag == 5) ? UIImage.init(systemName: "record.circle") : UIImage.init(systemName: "circle")
        self.imgDays.image = (sender.tag == 6) ? UIImage.init(systemName: "record.circle") : UIImage.init(systemName: "circle")
        
        let quantity = Double(txtQuantity.text ?? "0.0") ?? 0.0
        let price = Double(txtPrice.text ?? "0.0") ?? 0.0
        txtTotal.text = "\((quantity * price).roundToDecimal(3))"

        if sender.tag == 1 {
            selectedUnit = "Pcs"
            lblQuantity.text = "Pcs"
            viewFeetHeight.isHidden = true
        } else if sender.tag == 2 {
            selectedUnit = "sqft"
            lblQuantity.text = "sqft"
            viewFeetHeight.isHidden = false
        } else if sender.tag == 3 {
            selectedUnit = "KG"
            lblQuantity.text = "KG"
            viewFeetHeight.isHidden = true
        } else if sender.tag == 4 {
            selectedUnit = "Fixed"
            lblQuantity.text = "Fixed"
            viewFeetHeight.isHidden = true
            let price = Double(txtPrice.text ?? "0.0") ?? 0.0
            txtTotal.text = "\((price).roundToDecimal(3))"
        } else if sender.tag == 5 {
            selectedUnit = "RunningFeet"
            lblQuantity.text = "RunningFeet"
            viewFeetHeight.isHidden = true
        } else if sender.tag == 6 {
            selectedUnit = "Days"
            lblQuantity.text = "Days"
            viewFeetHeight.isHidden = true
        }
        
    }
    
    @IBAction func clickToAdd(_ sender: UIButton) {
        
        if let productname = self.txtProductName.text, productname.isEmpty {
            self.view.makeToast("Please Enter Product Name.")
        } else  if let productquantity = self.txtQuantity.text, productquantity.isEmpty {
            self.view.makeToast("Please Enter Product Quantity.")
        } else  if let productPrice = self.txtPrice.text, productPrice.isEmpty {
            self.view.makeToast("Please Enter Product Price.")
        } else {
            if isUpdate {
                self.UpdateProduct()
            } else {
                self.AddProduct()
            }
        }
    }
    
    @IBAction func clickToProductDropDown(_ sender: UIButton) {
        
        tblProductHSN.isHidden = true
        self.imgPcs.image = UIImage.init(systemName: "circle")
        self.imgSquareFeet.image = UIImage.init(systemName: "circle")
        self.imgKG.image = UIImage.init(systemName: "circle")
        self.imgFixed.image = UIImage.init(systemName: "circle")
        self.imgRunningFeet.image = UIImage.init(systemName: "circle")
        self.imgDays.image = UIImage.init(systemName: "circle")
        
        if tblProduct.isHidden {
            btnProductDropdown.setImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
            animate(toogle: true, type: btnProductDropdown)
        } else {
            btnProductDropdown.setImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
            animate(toogle: false, type: btnProductDropdown)
        }
    }
    
    @IBAction func clickToProductHSNDropDown(_ sender: UIButton) {
        
        tblProduct.isHidden = true
        self.imgPcs.image = UIImage.init(systemName: "circle")
        self.imgSquareFeet.image = UIImage.init(systemName: "circle")
        self.imgKG.image = UIImage.init(systemName: "circle")
        self.imgFixed.image = UIImage.init(systemName: "circle")
        self.imgRunningFeet.image = UIImage.init(systemName: "circle")
        self.imgDays.image = UIImage.init(systemName: "circle")
        
        if tblProductHSN.isHidden {
            btnProductHSNDropdown.setImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
            animateHSN(toogle: true, type: btnProductHSNDropdown)
        } else {
            btnProductHSNDropdown.setImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
            animateHSN(toogle: false, type: btnProductHSNDropdown)
        }
    }

    
}

extension InvoiceAddProductVC : UITextFieldDelegate {
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == txtProductName {
            if let text = txtProductName.text,
               let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                if (updatedText.isEmpty) {
                    txtGST.text = ""
                    txtHSNORSAC.text = ""
                    txtPrice.text = ""
                    selectedUnit = ""
                    txtSizeInch_1.text = ""
                    txtSizeInch_2.text = ""
                    self.imgPcs.image = UIImage.init(systemName: "record.circle")
                    lblQuantity.text = "Pcs"
                    viewFeetHeight.isHidden = true
                    arrProductData = arrFilterProductData
                    animate(toogle: false, type: btnProductDropdown)
                    tblProduct.isHidden = true
                } else {
                    arrProductData = arrFilterProductData.filter { $0.product_name?.lowercased().range(of: updatedText.lowercased()) != nil
                    }
                    if arrProductData.count > 0 {
                        tblProduct.isHidden = false
                        animate(toogle: true, type: btnProductDropdown)
                    } else {
                        tblProduct.isHidden = true
                        animate(toogle: false, type: btnProductDropdown)
                    }
                }
            } else {
                tblProduct.isHidden = true
                animate(toogle: false, type: btnProductDropdown)
                arrProductData = arrFilterProductData
            }
            self.tblProduct.reloadData()
        } else if textField == txtHSNORSAC {
            if let text = txtHSNORSAC.text,
               let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,
                                                           with: string)
                if (updatedText.isEmpty) {
                    txtGST.text = ""
                    txtHSNORSAC.text = ""
                    txtPrice.text = ""
                    selectedUnit = ""
                    txtSizeInch_1.text = ""
                    txtSizeInch_2.text = ""
                    self.imgPcs.image = UIImage.init(systemName: "record.circle")
                    lblQuantity.text = "Pcs"
                    viewFeetHeight.isHidden = true
                    arrProductData = arrFilterProductData
                    animateHSN(toogle: false, type: btnProductHSNDropdown)
                    tblProductHSN.isHidden = true
                } else {
                    arrProductData = arrFilterProductData.filter { $0.product_hsn?.lowercased().range(of: updatedText.lowercased()) != nil
                    }
                    if arrProductData.count > 0 {
                        tblProductHSN.isHidden = false
                        animateHSN(toogle: true, type: btnProductHSNDropdown)
                    } else {
                        tblProductHSN.isHidden = true
                        animateHSN(toogle: false, type: btnProductHSNDropdown)
                    }
                }
            } else {
                tblProductHSN.isHidden = true
                animateHSN(toogle: false, type: btnProductHSNDropdown)
                arrProductData = arrFilterProductData
            }
            self.tblProductHSN.reloadData()
            
        } else if textField == txtSizeInch_1 {
            if let textSizeInch1 = txtSizeInch_1.text,
               let textRangeSizeInch1 = Range(range, in: textSizeInch1) {
                let txt1 = textSizeInch1.replacingCharacters(in: textRangeSizeInch1,with: string)
                let inch1 = Double(txt1) ?? 0.0
                let inch2 = Double(txtSizeInch_2.text ?? "0.0") ?? 0.0
                let SquareFeet = (inch1 * inch2) / 144
                txtQuantity.text = "\(SquareFeet.roundToDecimal(3))"
                let price = Double(txtPrice.text ?? "") ?? 0.0
                txtTotal.text = "\((SquareFeet * price).roundToDecimal(3))"
            }
        } else if textField == txtSizeInch_2 {
            if let textSizeInch2 = txtSizeInch_2.text,
               let textRangeSizeInch2 = Range(range, in: textSizeInch2) {
                let txt2 = textSizeInch2.replacingCharacters(in: textRangeSizeInch2,with: string)
                let inch1 = Double(txtSizeInch_1.text ?? "0.0") ?? 0.0
                let inch2 = Double(txt2) ?? 0.0
                let SquareFeet = (inch1 * inch2) / 144
                txtQuantity.text = "\(SquareFeet.roundToDecimal(3))"
                let price = Double(txtPrice.text ?? "") ?? 0.0
                txtTotal.text = "\((SquareFeet * price).roundToDecimal(3))"
            }
        } else if textField == txtQuantity {
        
            if selectedUnit != "Fixed" {
                if let textQuantity = txtQuantity.text,
                   let textRangeQuantity = Range(range, in: textQuantity){
                    let updatedTextQuantity = textQuantity.replacingCharacters(in: textRangeQuantity,with: string)
                    let quantity = Double(updatedTextQuantity) ?? 0.0
                    let price = Double(txtPrice.text ?? "0.0") ?? 0.0
                    txtTotal.text = "\((quantity * price).roundToDecimal(3))"
                }
            } else {
                    let price = Double(txtPrice.text ?? "0.0") ?? 0.0
                    txtTotal.text = "\((price).roundToDecimal(3))"
            }
        } else if textField == txtPrice {
            if selectedUnit != "Fixed" {
                if let textQuantity = txtPrice.text,
                   let textRangeQuantity = Range(range, in: textQuantity){
                    let updatedTextQuantity = textQuantity.replacingCharacters(in: textRangeQuantity,with: string)
                    let quantity = Double(updatedTextQuantity) ?? 0.0
                    let price = Double(txtQuantity.text ?? "0.0") ?? 0.0
                    txtTotal.text = "\((quantity * price).roundToDecimal(3))"
                }
            } else {
                if let textQuantity = txtPrice.text,
                   let textRangeQuantity = Range(range, in: textQuantity){
                    let updatedTextQuantity = textQuantity.replacingCharacters(in: textRangeQuantity,with: string)
                    let price = Double(updatedTextQuantity) ?? 0.0
                    txtTotal.text = "\((price).roundToDecimal(3))"
                }
            }
        }
        return true
    }

}

extension InvoiceAddProductVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProductData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblProduct.dequeueReusableCell(withIdentifier: "ManageProductsCell", for: indexPath) as? ManageProductsCell {
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        txtProductName.text = arrProductData[indexPath.row].product_name
        txtGST.text = arrProductData[indexPath.row].product_gst
        txtHSNORSAC.text = arrProductData[indexPath.row].product_hsn
        txtPrice.text = arrProductData[indexPath.row].product_price
        selectedUnit = arrProductData[indexPath.row].product_unit ?? ""
        txtSizeInch_1.text = arrProductData[indexPath.row].product_inch_1
        txtSizeInch_2.text = arrProductData[indexPath.row].product_inch_2
        
        self.imgPcs.image = UIImage.init(systemName: "circle")
        self.imgSquareFeet.image = UIImage.init(systemName: "circle")
        self.imgKG.image = UIImage.init(systemName: "circle")
        self.imgFixed.image = UIImage.init(systemName: "circle")
        self.imgRunningFeet.image = UIImage.init(systemName: "circle")
        self.imgDays.image = UIImage.init(systemName: "circle")

        if selectedUnit == "Pcs" {
            self.imgPcs.image = UIImage.init(systemName: "record.circle")
            lblQuantity.text = "Pcs"
            viewFeetHeight.isHidden = true
        } else if selectedUnit == "sqft" {
            self.imgSquareFeet.image = UIImage.init(systemName: "record.circle")
            lblQuantity.text = "sqft"
            viewFeetHeight.isHidden = false
        } else if selectedUnit == "KG" {
            self.imgKG.image = UIImage.init(systemName: "record.circle")
            lblQuantity.text = "KG"
            viewFeetHeight.isHidden = true
        } else if selectedUnit == "Fixed" {
            self.imgFixed.image = UIImage.init(systemName: "record.circle")
            lblQuantity.text = "Fixed"
            viewFeetHeight.isHidden = true
        } else if selectedUnit == "RunningFeet" {
            self.imgRunningFeet.image = UIImage.init(systemName: "record.circle")
            lblQuantity.text = "RunningFeet"
            viewFeetHeight.isHidden = true
        } else if selectedUnit == "Days" {
            self.imgDays.image = UIImage.init(systemName: "record.circle")
            lblQuantity.text = "Days"
            viewFeetHeight.isHidden = true
        }

        btnProductDropdown.setImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        animate(toogle: false, type: btnProductDropdown)
        btnProductHSNDropdown.setImage(UIImage(systemName: "chevron.down.circle.fill"), for: .normal)
        animateHSN(toogle: false, type: btnProductHSNDropdown)

    }
    
}
