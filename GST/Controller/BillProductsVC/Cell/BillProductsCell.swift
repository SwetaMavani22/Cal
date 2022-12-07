//
//  BillProductsCell.swift
//  GST
//
//  Created by ViPrak-Ankit on 28/01/22.
//

import UIKit

class BillProductsCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var lblProductName : UILabel!
    @IBOutlet var lblProductHSN : UILabel!
    @IBOutlet var lblProductGST : UILabel!
    @IBOutlet var lblProductUnit : UILabel!
    @IBOutlet var lblProductAmount : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
