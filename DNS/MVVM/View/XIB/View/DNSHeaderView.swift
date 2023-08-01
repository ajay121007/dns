//
//  DNSHeaderView.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import UIKit
//import MMLoadingButton
import SSSpinnerButton

class DNSHeaderView: UIView {

    @IBOutlet weak var vwProcessing: UIView!
    @IBOutlet weak var constraintWidthBtnStart: NSLayoutConstraint!
    @IBOutlet weak var lblProcessing: UILabel!
    @IBOutlet weak var btnStart: SSSpinnerButton!
    @IBOutlet weak var constraintBottomStackVw: NSLayoutConstraint!
    
    static var share: DNSHeaderView? = nil
    
    public var btnStartClick : ((DNSHeaderView)->Void)?
    
    static var instance: DNSHeaderView {
        
        if (share == nil) {
            share = Bundle(for: self).loadNibNamed("DNSHeaderView",
                                                   owner: nil,
                                                   options: nil)?.first as? DNSHeaderView
        }
        return share!
    }
    
    @IBAction func btnStartAction(_ sender: Any) {
        self.btnStartClick?(self)
    }
    

}
