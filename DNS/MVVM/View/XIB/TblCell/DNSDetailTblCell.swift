//
//  DNSDetailTblCell.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import UIKit

class DNSDetailTblCell: UITableViewCell {

    @IBOutlet weak var lblIpAddress: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblFlag: UILabel!
    @IBOutlet weak var lblIP: UILabel!
    
    public var vwTouchClick : ((DNSDetailTblCell)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.vwTouchClick?(self)
    }
    
}
