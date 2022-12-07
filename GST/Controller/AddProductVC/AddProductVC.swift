//
//  AddProductVC.swift
//  GST
//
//  Created by ViPrak-Ankit on 28/01/22.
//

import UIKit
import CoreData

class AddProductVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var txtProductName: AkiraTextField!
    @IBOutlet weak var txtHSNORSAC: AkiraTextField!
    @IBOutlet weak var txtGST: AkiraTextField!
    @IBOutlet weak var txtPrice: AkiraTextField!
    @IBOutlet weak var txtSizeInch_1: AkiraTextField!
    @IBOutlet weak var txtSizeInch_2: AkiraTextField!
    @IBOutlet weak var imgPcs: UIImageView!
    @IBOutlet weak var imgSquareFeet: UIImageView!
    @IBOutlet weak var imgKG: UIImageView!
    @IBOutlet weak var imgFixed: UIImageView!
    @IBOutlet weak var imgRunningFeet: UIImageView!
    @IBOutlet weak var imgDays: UIImageView!
    
    @IBOutlet weak var SquareFeetHeightConstrain : NSLayoutConstraint!
    // MARK: - Variable Decleration
    
    var selectedUnit = ""
    var isUpdate = false
    var selecteProduct = ManageProduct()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setDefault()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SquareFeetHeightConstrain.constant = 0
        
        if isUpdate {
            
            txtProductName.text = selecteProduct.product_name
            txtGST.text = selecteProduct.product_gst
            txtHSNORSAC.text = selecteProduct.product_hsn
            txtPrice.text = selecteProduct.product_price
            selectedUnit = selecteProduct.product_unit ?? ""
            txtSizeInch_1.text = selecteProduct.product_inch_1
            txtSizeInch_2.text = selecteProduct.product_inch_2

            if selectedUnit == "Pcs" {
                self.imgPcs.image = UIImage.init(systemName: "record.circle")
                SquareFeetHeightConstrain.constant = 0
            } else if selectedUnit == "sqft" {
                self.imgSquareFeet.image = UIImage.init(systemName: "record.circle")
                SquareFeetHeightConstrain.constant = 0
            } else if selectedUnit == "KG" {
                self.imgKG.image = UIImage.init(systemName: "record.circle")
                SquareFeetHeightConstrain.constant = 0
            } else if selectedUnit == "Fixed" {
                self.imgFixed.image = UIImage.init(systemName: "record.circle")
                SquareFeetHeightConstrain.constant = 0
            } else if selectedUnit == "RunningFeet" {
                self.imgRunningFeet.image = UIImage.init(systemName: "record.circle")
                SquareFeetHeightConstrain.constant = 0
            } else if selectedUnit == "Days" {
                self.imgDays.image = UIImage.init(systemName: "record.circle")
                SquareFeetHeightConstrain.constant = 0
            }
        }
    }
    
    // MARK: - Private Method
    func setDefault() {
        
    }
    
    func AddProduct() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ManageProduct",in: context)!
        let product = NSManagedObject(entity: entity,insertInto: context)
        
        product.setValue(txtProductName.text, forKey: "product_name")
        product.setValue(txtGST.text, forKey: "product_gst")
        product.setValue(txtHSNORSAC.text, forKey: "product_hsn")
        product.setValue(txtPrice.text, forKey: "product_price")
        product.setValue(Date(), forKey: "product_id")
        product.setValue(selectedUnit, forKey: "product_unit")
        product.setValue(txtSizeInch_1.text, forKey: "product_inch_1")
        product.setValue(txtSizeInch_2.text, forKey: "product_inch_2")

        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            self.view.makeToast("Product Not Save.")
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func UpdateProduct() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<ManageProduct>(entityName: "ManageProduct")
        fetchRequest.predicate = NSPredicate(format: "product_id = %@", selecteProduct.product_id! as CVarArg )
        do
        {
            let value = try  context.fetch(fetchRequest)
            let product = value[0] as NSManagedObject
            product.setValue(txtProductName.text, forKey: "product_name")
            product.setValue(txtGST.text, forKey: "product_gst")
            product.setValue(txtHSNORSAC.text, forKey: "product_hsn")
            product.setValue(txtPrice.text, forKey: "product_price")
            product.setValue(selecteProduct.product_id, forKey: "product_id")
            product.setValue(selectedUnit, forKey: "product_unit")
            product.setValue(txtSizeInch_1.text, forKey: "product_inch_1")
            product.setValue(txtSizeInch_2.text, forKey: "product_inch_2")

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
        
       if self.imgSquareFeet.image == UIImage.init(systemName: "record.circle") {
            SquareFeetHeightConstrain.constant = 0
        } else {
            SquareFeetHeightConstrain.constant = 0
        }
        
        if sender.tag == 1 {
            selectedUnit = "Pcs"
        } else if sender.tag == 2 {
            selectedUnit = "sqft"
        } else if sender.tag == 3 {
            selectedUnit = "KG"
        } else if sender.tag == 4 {
            selectedUnit = "Fixed"
        } else if sender.tag == 5 {
            selectedUnit = "RunningFeet"
        } else if sender.tag == 6 {
            selectedUnit = "Days"
        }
    }
    
    @IBAction func clickToAdd(_ sender: UIButton) {
        
        if let productname = self.txtProductName.text, productname.isEmpty {
            self.view.makeToast("Please Enter Product Name.")
        } else {
            if isUpdate {
                self.UpdateProduct()
            } else {
                self.AddProduct()
            }
        }
    }

}
