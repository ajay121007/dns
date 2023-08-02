//
//  Extension.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import Foundation
import UIKit
import SystemConfiguration

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
        DispatchQueue.main.async {
            self.present(alertCon, animated: true, completion: nil)
        }
        
    }
    
}

public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
