//
//  DNSTitleHeaderView.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import UIKit

class DNSTitleHeaderView: UIView {

    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    static var share: DNSTitleHeaderView? = nil

    static var instance: DNSTitleHeaderView {
        
       // if (share == nil) {
            share = Bundle(for: self).loadNibNamed("DNSTitleHeaderView",
                                                   owner: nil,
                                                   options: nil)?.first as? DNSTitleHeaderView
        //}
        return share!
    }
    
}
