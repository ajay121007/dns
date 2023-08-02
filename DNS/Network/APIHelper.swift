//
//  APIHelper.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import Foundation
import UIKit

func server(url:String,apiMethod:String="Get",completion:@escaping([String:Any],Data?,Bool)->()) {
    if Reachability.isConnectedToNetwork(){
        let Url = String(format: url)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = apiMethod
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    //print("response json:- ",json as? [String:Any] ?? [:])
                    completion(json as? [String:Any] ?? [:],data, true)
                } catch {
                    let dict = ["status_code":500,"error":error.localizedDescription ] as [String : Any]
                    let jsonData = dict.jsonStringRepresentation?.data(using: .utf8) ?? Data()
                    completion([:],jsonData,false)
                }
            }
        }.resume()
    }else{
        let dict = ["status_code":501,"error":"Please connect to the internet"] as [String : Any]
        let jsonData = dict.jsonStringRepresentation?.data(using: .utf8) ?? Data()
        completion(dict,jsonData, false)
    }
}
