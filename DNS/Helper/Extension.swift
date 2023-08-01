//
//  Extension.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import Foundation
import UIKit
import Alamofire

extension UITableView {
    /**
     Register cell nib without identifier
     */
    func registerNib<Cell: UITableViewCell>(cell: Cell.Type) {
        let nibName = String(describing: Cell.self)
        
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
        
    }
    
    
    /**
     Register header footer
     */
    
    func registerHeaderFooterNib<View: UIView>(view: View.Type) {
        let viewName = String(describing: View.self)
        
        register(UINib(nibName: viewName, bundle: nil), forHeaderFooterViewReuseIdentifier: viewName)
    }
}

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

class Logger {

    class func log(_ msg:Any){
        #if DEBUG
            print("\(msg)")
        #endif
    }
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

extension String {

    func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map {
            if let arg = $0 as? Int { return String(arg) }
            if let arg = $0 as? Float { return String(arg) }
            if let arg = $0 as? Double { return String(arg) }
            if let arg = $0 as? Int64 { return String(arg) }
            if let arg = $0 as? String { return String(arg) }
            if let arg = $0 as? Character { return String(arg) }

            return "(null)"
        } as [CVarArg]

        return String.init(format: self, arguments: args)
    }

}


extension String{
    
    func countryFlag() -> String {
      let base = 127397
      var tempScalarView = String.UnicodeScalarView()
      for i in self.utf16 {
        if let scalar = UnicodeScalar(base + Int(i)) {
          tempScalarView.append(scalar)
        }
      }
      return String(tempScalarView)
    }
    
}

extension UIViewController{
    
    func showAlert(title:String,msg:String){
        
        let alertCon = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertCon.addAction(alertAction)
        
        self.present(alertCon, animated: true, completion: nil)
        
    }
    
}
