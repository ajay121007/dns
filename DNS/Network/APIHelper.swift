//
//  APIHelper.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import Foundation
import Alamofire
import UIKit


func server(url:String,apiMethod:HTTPMethod,param:[String:Any]?,header:HTTPHeaders?,completion:@escaping([String:Any],Data?,Bool)->()){
   
    print("baseurl:-",url)
    print("parameter:-",param)
    if Connectivity.isConnectedToInternet(){
       
        AF.request(url, method: apiMethod, parameters: param, headers: header).responseJSON { (response) in
           
            if let data = response.data, let str = String(data: data, encoding: .utf8){
                //print("server error:-",str)
                Logger.log("server error:- \(str)")
            }
            
           // print("response.response?.statusCode:-",response.response?.statusCode)
            switch (response.result){
            
            case .success(_):
                
                //if let dict = response.value as? [String:Any]{
                completion(response.value as? [String:Any] ?? [:],response.data, true)
                //}
                break
            case .failure(let error):
                let dict = ["status_code":500,"error":error.localizedDescription ] as [String : Any]
                let jsonData = dict.jsonStringRepresentation?.data(using: .utf8) ?? Data()
                completion([:],jsonData,false)
                break
            }
        }
    }else{
        let dict = ["status_code":501,"error":"Please connect to the internet"] as [String : Any]
        let jsonData = dict.jsonStringRepresentation?.data(using: .utf8) ?? Data()
        completion(dict,jsonData, false)
    }
    
    
}
