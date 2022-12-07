//
//  Constants.swift
//  ChannelBusiness

import Foundation
import UIKit

var appName = "GST Invoice"
var Defualtss = UserDefaults.standard

var alertMissing = "Sorry we can’t found, something is missing!"
var alertNetwork = "Please check your internet connection!"

var BussinessDetails = ModelBussinesDetails()

struct colors {
    static let themeColor             =  "1CB0D9"
    static let blackColor             =  "373737"
    static let grayColor              =  "CAC9C9"
    static let lightgraybgColor       =  "FAFAFA"
    static let themeBlueColor         =  "3999FF"
}

struct UDKey {
    static let kFirsttimeopen         =  "isFirsttimeopen"
    static let kBussinessDetails      =  "BussinessDetails"
    static let kLastInvoiceDetail     =  "LastInvoiceDetail"
    static let kLastInvoice           =  "LastInvoice"
}

let arrState = [ "Andhra Pradesh",
                "Arunachal Pradesh",
                "Assam",
                "Bihar",
                "Chhattisgarh",
                "Goa",
                "Gujarat",
                "Haryana",
                "Himachal Pradesh",
                "Jammu and Kashmir",
                "Jharkhand",
                "Karnataka",
                "Kerala",
                "Madhya Pradesh",
                "Maharashtra",
                "Manipur",
                "Meghalaya",
                "Mizoram",
                "Nagaland",
                "Odisha",
                "Punjab",
                "Rajasthan",
                "Sikkim",
                "Tamil Nadu",
                "Telangana",
                "Tripura",
                "Uttarakhand",
                "Uttar Pradesh",
                "West Bengal",
                "Andaman and Nicobar Islands",
                "Chandigath",
                "Dadra and Nagar Haveli",
                "Daman and Diu",
                "Delhi",
                "Lakshadweep",
                "Puducherry"]

func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func isValidGST(gst: String) -> Bool {
    let gstRegEx = "^([0][1-9]|[1-2][0-9]|[3][0-7])([a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}[zZ]{1}[0-9a-zA-Z]{1})+$"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", gstRegEx)
    return emailPred.evaluate(with: gst)
}

