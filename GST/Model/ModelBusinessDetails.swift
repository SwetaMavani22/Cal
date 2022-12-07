//
//  ModelBusinessDetails.swift
//  GST
//
//  Created by user1 on 01/02/22.
//

import Foundation

class ModelBussinesDetails:NSObject,NSCoding {
    
    var InvoiceTitle = ""
    var Name = ""
    var Address = ""
    var Email = ""
    var City = ""
    var State = ""
    var Zipcode = ""
    var PhoneNo = ""
    var PanNo = ""
    var GstNo = ""
    var BankName = ""
    var AccountNo = ""
    var IFSCCode = ""
    var TermsAndCondition = ""
    var DeliveryTerms = ""
    var DeliveryNote = ""
    var TermsOfPayment = ""
    var SupplierRef = ""
    var OtherRef = ""
    var DispatchDocNo = ""
    var DispatchThrough = ""
    var Destination = ""

    override init() {
        super.init()
    }
    
    init(dic:[String:Any]) {
        
        InvoiceTitle = dic["InvoiceTitle"] as? String ?? ""
        Name = dic["Name"] as? String ?? ""
        Address = dic["Address"] as? String ?? ""
        Email = dic["Email"] as? String ?? ""
        City = dic["City"] as? String ?? ""
        State = dic["State"] as? String ?? ""
        Zipcode = dic["Zipcode"] as? String ?? ""
        PhoneNo = dic["PhoneNo"] as? String ?? ""
        PanNo = dic["PanNo"] as? String ?? ""
        GstNo = dic["GstNo"] as? String ?? ""
        BankName = dic["BankName"] as? String ?? ""
        AccountNo = dic["AccountNo"] as? String ?? ""
        IFSCCode = dic["IFSCCode"] as? String ?? ""
        TermsAndCondition = dic["TermsAndCondition"] as? String ?? ""
        DeliveryTerms = dic["DeliveryTerms"] as? String ?? ""
        DeliveryNote = dic["DeliveryNote"] as? String ?? ""
        TermsOfPayment = dic["TermsOfPayment"] as? String ?? ""
        SupplierRef = dic["SupplierRef"] as? String ?? ""
        OtherRef = dic["OtherRef"] as? String ?? ""
        DispatchDocNo = dic["DispatchDocNo"] as? String ?? ""
        DispatchThrough = dic["DispatchThrough"] as? String ?? ""
        Destination = dic["Destination"] as? String ?? ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.InvoiceTitle = aDecoder.decodeObject(forKey: "InvoiceTitle") as? String ?? ""
        self.Name = aDecoder.decodeObject(forKey: "Name") as? String ?? ""
        self.Address = aDecoder.decodeObject(forKey: "Address") as? String ?? ""
        self.Email = aDecoder.decodeObject(forKey: "Email") as? String ?? ""
        self.City = aDecoder.decodeObject(forKey: "City") as? String ?? ""
        self.State = aDecoder.decodeObject(forKey: "State") as? String ?? ""
        self.Zipcode = aDecoder.decodeObject(forKey: "Zipcode") as? String ?? ""
        self.PhoneNo = aDecoder.decodeObject(forKey: "PhoneNo") as? String ?? ""
        self.PanNo = aDecoder.decodeObject(forKey: "PanNo") as? String ?? ""
        self.GstNo = aDecoder.decodeObject(forKey: "GstNo") as? String ?? ""
        self.BankName = aDecoder.decodeObject(forKey: "BankName") as? String ?? ""
        self.AccountNo = aDecoder.decodeObject(forKey: "AccountNo") as? String ?? ""
        self.IFSCCode = aDecoder.decodeObject(forKey: "IFSCCode") as? String ?? ""
        self.TermsAndCondition = aDecoder.decodeObject(forKey: "TermsAndCondition") as? String ?? ""
        self.DeliveryTerms = aDecoder.decodeObject(forKey: "DeliveryTerms") as? String ?? ""
        self.DeliveryNote = aDecoder.decodeObject(forKey: "DeliveryNote") as? String ?? ""
        self.TermsOfPayment = aDecoder.decodeObject(forKey: "TermsOfPayment") as? String ?? ""
        self.SupplierRef = aDecoder.decodeObject(forKey: "SupplierRef") as? String ?? ""
        self.OtherRef = aDecoder.decodeObject(forKey: "OtherRef") as? String ?? ""
        self.DispatchDocNo = aDecoder.decodeObject(forKey: "DispatchDocNo") as? String ?? ""
        self.DispatchThrough = aDecoder.decodeObject(forKey: "DispatchThrough") as? String ?? ""
        self.Destination = aDecoder.decodeObject(forKey: "Destination") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(InvoiceTitle,forKey: "InvoiceTitle")
        aCoder.encode(Name,forKey: "Name")
        aCoder.encode(Address,forKey: "Address")
        aCoder.encode(Email,forKey: "Email")
        aCoder.encode(City,forKey: "City")
        aCoder.encode(State,forKey: "State")
        aCoder.encode(Zipcode,forKey: "Zipcode")
        aCoder.encode(PhoneNo,forKey: "PhoneNo")
        aCoder.encode(PanNo,forKey: "PanNo")
        aCoder.encode(GstNo,forKey: "GstNo")
        aCoder.encode(BankName,forKey: "BankName")
        aCoder.encode(AccountNo,forKey: "AccountNo")
        aCoder.encode(IFSCCode,forKey: "IFSCCode")
        aCoder.encode(TermsAndCondition,forKey: "TermsAndCondition")
        aCoder.encode(DeliveryTerms,forKey: "DeliveryTerms")
        aCoder.encode(DeliveryNote,forKey: "DeliveryNote")
        aCoder.encode(TermsOfPayment,forKey: "TermsOfPayment")
        aCoder.encode(SupplierRef,forKey: "SupplierRef")
        aCoder.encode(OtherRef,forKey: "OtherRef")
        aCoder.encode(DispatchDocNo,forKey: "DispatchDocNo")
        aCoder.encode(DispatchThrough,forKey: "DispatchThrough")
        aCoder.encode(Destination,forKey: "Destination")
    }
}
