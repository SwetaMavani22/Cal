//
//  InvoiceHistoryCell.swift
//  GST
//
//  Created by ViPrak-Ankit on 31/01/22.
//

import UIKit

class InvoiceHistoryCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var lblInvoiceNo : UILabel!
    @IBOutlet var lblInvoiceDate : UILabel!
    @IBOutlet var lblInvoiceName : UILabel!
    @IBOutlet var lblInvoicePDF : UILabel!
    @IBOutlet var lblInvoiceStatus : UILabel!
    @IBOutlet var lblInvoiceAmount : UILabel!
    @IBOutlet var btnView : UIButton!
    @IBOutlet var btnEdit : UIButton!
    @IBOutlet var btnChangeStatus : UIButton!
    @IBOutlet var btnDelete : UIButton!
    @IBOutlet var btnShare : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
