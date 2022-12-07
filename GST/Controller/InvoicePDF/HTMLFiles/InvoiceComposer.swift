//
//  PDFComposer.swift
//  GST
//
//  Created by Mavani on 05/02/22.
//

import Foundation
import PDFKit

class InvoiceComposer: NSObject {
    
    let pathToInvoiceHTMLIGST = Bundle.main.path(forResource: "invoiceIGST", ofType: "html")
    let pathToInvoiceHTMLCGST = Bundle.main.path(forResource: "invoiceCGST", ofType: "html")
    let pathToInvoiceHTML     = Bundle.main.path(forResource: "invoice", ofType: "html")
    let pathToNewInvoiceHTML     = Bundle.main.path(forResource: "Newinvoice", ofType: "html")

    let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")
    
    let pathToLastItemHTMLTemplate = Bundle.main.path(forResource: "last_item", ofType: "html")
        
    var pdfFilename: String!

    override init() {
        super.init()
    }
    
    func renderInvoice(invoicedata : CreateInvoice, items: [ManageInvoiceProduct] , BussinessData : ModelBussinesDetails) -> String! {
        
        do {
            var HTMLContent = ""
            //HTMLContent = try String(contentsOfFile: pathToNewInvoiceHTML!)
            if invoicedata.invoice_isGST {
                if invoicedata.invoice_state != invoicedata.invoice_receiver_state {
                    HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLIGST!)
                } else if invoicedata.invoice_state == invoicedata.invoice_receiver_state {
                     HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLCGST!)
                }
            } else {
                HTMLContent = try String(contentsOfFile: pathToInvoiceHTML!)
            }

          
            HTMLContent = HTMLContent.replacingOccurrences(of: "#COMPANY_NAME#", with: "Bussiness Name : \(BussinessData.InvoiceTitle)")

            if invoicedata.invoice_isGST {
                
                HTMLContent = HTMLContent.replacingOccurrences(of: "#SENDER_NAME#", with: "\(invoicedata.invoice_name ?? "")")
                
                HTMLContent = HTMLContent.replacingOccurrences(of: "#SENDER_INFO#", with: "\(invoicedata.invoice_address ?? ""),\(invoicedata.invoice_city ?? "")<br>\(invoicedata.invoice_state ?? ""),\(invoicedata.invoice_zipcode ?? "")<br>Phone No: \(invoicedata.invoice_phone ?? "")<br>GST No : \(invoicedata.invoice_gst ?? "")".replacingOccurrences(of: "\n", with: "<br>"))
                
                HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPIENT_NAME#", with: "\(invoicedata.invoice_receiver_name ?? "")")
                
                HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPIENT_INFO#", with: "\(invoicedata.invoice_receiver_address ?? ""),\(invoicedata.invoice_receiver_city ?? "")<br>\(invoicedata.invoice_receiver_state ?? ""),\(invoicedata.invoice_receiver_zipcode ?? "")<br>Phone No: \(invoicedata.invoice_receiver_phone ?? "")<br>GST No : \(invoicedata.invoice_receiver_gst ?? "")".replacingOccurrences(of: "\n", with: "<br>"))

            } else {
                HTMLContent = HTMLContent.replacingOccurrences(of: "#SENDER_NAME#", with: "Bussiness Name : \(invoicedata.invoice_name ?? "")")
                
                HTMLContent = HTMLContent.replacingOccurrences(of: "#SENDER_INFO#", with: "\(invoicedata.invoice_address ?? ""),\(invoicedata.invoice_city ?? "")<br>\(invoicedata.invoice_state ?? ""),\(invoicedata.invoice_zipcode ?? "")<br>Phone No: \(invoicedata.invoice_phone ?? "")".replacingOccurrences(of: "\n", with: "<br>"))
                
                HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPIENT_NAME#", with: "\(invoicedata.invoice_receiver_name ?? "")")
                
                HTMLContent = HTMLContent.replacingOccurrences(of: "#RECIPIENT_INFO#", with: "\(invoicedata.invoice_receiver_address ?? ""),\(invoicedata.invoice_receiver_city ?? "")<br>\(invoicedata.invoice_receiver_state ?? ""),\(invoicedata.invoice_receiver_zipcode ?? "")<br>Phone No: \(invoicedata.invoice_receiver_phone ?? "")".replacingOccurrences(of: "\n", with: "<br>"))
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_DATE#", with: "\(invoicedata.invoice_date ?? "")")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#INVOICE_NO#", with: invoicedata.invoice_no ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#E_Way#", with: invoicedata.invoice_eway ?? "")

            HTMLContent = HTMLContent.replacingOccurrences(of: "#SUPPLIER_REF#", with: invoicedata.invoice_supplier ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DISPATCH_DOC_NO#", with: invoicedata.invoice_dispatchdocno ?? "")

            HTMLContent = HTMLContent.replacingOccurrences(of: "#DISPATCH_THROUGH#", with: invoicedata.invoice_dispatchthrough ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TERMS_OF_PAYMENT#", with: invoicedata.invoice_termsofpayment ?? "")

            HTMLContent = HTMLContent.replacingOccurrences(of: "#DELIVERY_NOTE#", with: invoicedata.invoice_deliverynote ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DELIVERY_DATE#", with: invoicedata.invoice_deliverydate ?? "")

            HTMLContent = HTMLContent.replacingOccurrences(of: "#DESTINATION#", with: invoicedata.invoice_destination ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DELIVERY_TERMS#", with: invoicedata.invoice_deliveryterms ?? "")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#BANK_NAME#", with: invoicedata.invoice_bankname ?? "")

            HTMLContent = HTMLContent.replacingOccurrences(of: "#ACCOUNT_NO#", with: invoicedata.invoice_accountno ?? "")

            HTMLContent = HTMLContent.replacingOccurrences(of: "#IFSC_CODE#", with: invoicedata.invoice_ifsc ?? "")

            HTMLContent = HTMLContent.replacingOccurrences(of: "#TERMS_CONDITION#", with: invoicedata.invoice_termsandcondition ?? "")

            var allItems = ""
            
            for i in 0..<items.count {
                var itemHTMLContent: String!
                
                if i != items.count - 1 {
                    itemHTMLContent = try String(contentsOfFile: pathToSingleItemHTMLTemplate!)
                }
                else {
                    itemHTMLContent = try String(contentsOfFile: pathToLastItemHTMLTemplate!)
                }
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#ITEM_DESC#", with: items[i].invoice_product_name ?? "")
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#HSN#", with: items[i].invoice_product_hsn ?? "")

                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#QTY#", with: items[i].invoice_product_quantity ?? "")

                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#UNIT#", with: items[i].invoice_product_unit ?? "")

                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#AMOUNT#", with: items[i].invoice_product_total ?? "")

                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#PRICE#", with: items[i].invoice_product_price ?? "")
                
                allItems += itemHTMLContent
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#SUB_TOTAL_AMOUNT#", with: "\(invoicedata.summary_subtotal)")
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#SHIPPING_CHARGE#", with: "\(invoicedata.summary_shippingCharge)")

            HTMLContent = HTMLContent.replacingOccurrences(of: "#DISCOUNT#", with: "\(invoicedata.summary_discount)")


            if invoicedata.invoice_isGST {
                if invoicedata.invoice_state != invoicedata.invoice_receiver_state {
                    HTMLContent = HTMLContent.replacingOccurrences(of: "#IGST#", with: "\(invoicedata.summary_igst)")
                } else if invoicedata.invoice_state == invoicedata.invoice_receiver_state {
                    HTMLContent = HTMLContent.replacingOccurrences(of: "#CGST#", with: "\(invoicedata.summary_cgst)")
                    HTMLContent = HTMLContent.replacingOccurrences(of: "#SGST#", with: "\(invoicedata.summary_sgst)")
                }
            } 
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TOTAL_AMOUNT#", with: "\(invoicedata.summary_total)")

            let formatter = NumberFormatter()
            formatter.numberStyle = .spellOut
            let number = Int(invoicedata.summary_total)
            let spelledOutNumber = formatter.string(for: NSNumber(integerLiteral: number))!

            HTMLContent = HTMLContent.replacingOccurrences(of: "#WORD_AMOUNT#", with: "\(spelledOutNumber)")

            return HTMLContent
        }
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    
    func exportHTMLContentToPDF(HTMLContent: String , pdfName : String) {
        
        let printPageRenderer = CustomPrintPageRenderer()
        
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        pdfFilename = "\(pdfName).pdf"
        pdfData?.write(toFile: "\(pdfName).pdf", atomically: true)
        
        print(pdfFilename)
    }
    
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        for i in 0..<printPageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            printPageRenderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        return data
    }
    
}

