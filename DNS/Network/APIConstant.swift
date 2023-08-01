//
//  APIConstant.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import Foundation

struct APIConstant{
    static let kAPIDomain = "bash.ws"
    static let kGetIP = "https://\(kAPIDomain)/dnsleak/test/%d?json"
    static let kPingServer = "https://%d.%d.\(kAPIDomain)"
}


