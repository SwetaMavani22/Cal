//
//  InvoiceVC.swift
//  GST
//
//  Created by Mavani on 05/02/22.
//

import UIKit
import MessageUI
import WebKit

class InvoiceVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var webPreview: WKWebView!

    // MARK: - Variable Decleration
    var invoiceComposer = InvoiceComposer()
    var HTMLContent = ""
    var billProductData = [ManageInvoiceProduct]()
    var invoiceData = CreateInvoice()
    var BussinessData = ModelBussinesDetails()
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        webPreview.navigationDelegate = self
        self.webPreview.contentMode = .scaleAspectFit

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"

        if let data = UserDefaults.standard.data(forKey:  UDKey.kBussinessDetails) {
            do {
                if let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? ModelBussinesDetails {
                    self.BussinessData = data
                }
            } catch {
                print("Something went wrong.")
            }
        }
        createInvoiceAsHTML()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Custom Methods
    func createInvoiceAsHTML() {
        invoiceComposer = InvoiceComposer()
        if let invoiceHTML = invoiceComposer.renderInvoice(invoicedata: invoiceData, items: billProductData, BussinessData: self.BussinessData) {
            
            print(invoiceHTML)
            
            webPreview.loadHTMLString(invoiceHTML, baseURL:  Bundle.main.bundleURL)
            HTMLContent = invoiceHTML
        }
    }
    
    func createPDF(html: String, formmatter: UIViewPrintFormatter, filename: String) -> String {
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(formmatter, startingAtPageAt: 0)
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        
        for i in 1...render.numberOfPages {

            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }

        UIGraphicsEndPDFContext();

        let path = "\(NSTemporaryDirectory())\(filename).pdf"
        pdfData.write(toFile: path, atomically: true)
        print("open \(path)")
        
        return path
    }

    // MARK: IBAction Methods
    @IBAction func exportToPDF(_ sender: AnyObject) {
        
    }
    
    @IBAction func clickToDone(_ sender: UIButton) {
        self.gotoHomeVC()
    }

}

extension InvoiceVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        let path = createPDF(html: HTMLContent, formmatter: webView.viewPrintFormatter(), filename: "\(dateFormatter.string(from: invoiceData.invoice_id ?? Date()))")
        print("PDF location: \(path)")
    }
}
