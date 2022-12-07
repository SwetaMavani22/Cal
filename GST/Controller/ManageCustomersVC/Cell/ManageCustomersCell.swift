//
//  ManageCustomersCell.swift
//  GST
//
//  Created by ViPrak-Ankit on 31/01/22.
//

import UIKit

class ManageCustomersCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblAddress : UILabel!
    @IBOutlet var lblCity : UILabel!
    @IBOutlet var lblGST : UILabel!
    @IBOutlet var lblPAN : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
