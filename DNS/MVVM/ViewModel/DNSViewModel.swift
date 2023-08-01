//
//  DNSViewModel.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import UIKit

class DNSViewModel: NSObject {

    private static var privateShared : DNSViewModel?
    
    class func shared() -> DNSViewModel { // change class to final to prevent override
        guard let uwShared = privateShared else {
            privateShared = DNSViewModel()
            return privateShared!
        }
        return uwShared
    }
    
    class func destroy() {privateShared = nil}
    private override init() {print("init singleton")}
    deinit {print("deinit singleton")}
    
    private var ipListArray : [DNSModel]? = []
    private var dnsListArray : [DNSModel]? = []
    
    public enum ipType : String{
        case ip = "ip"
        case dns = "dns"
        case conclusion = "conclusion"
    }
    
}

//MARK: API
extension DNSViewModel{
    
    public func random(min: Int, max: Int) -> Int {
        return Int.random(in: min..<max)
    }
    
    public func pinServer(completion:@escaping (Int)->Void){
        let wg = DispatchGroup()
        let rSubDomainId1 = random(min: 1000000, max: 9999999)
        for i in 0...10 {
            let initUrl = String(format: APIConstant.kPingServer, i,rSubDomainId1)
            Logger.log("initUrl:-\(initUrl)")
            wg.enter()
            URLSession.shared.dataTask(with: URL(string: initUrl)!) { (_, _, _) in
                wg.leave()
            }.resume()
        }
        wg.wait()
        completion(rSubDomainId1)
    }
    
    public func getIPList(subDomainId:Int,completion:@escaping (Bool,String)->Void){
        let getUrl = String(format: APIConstant.kGetIP, subDomainId)
        server(url: getUrl, apiMethod: .get, param: nil, header: nil) { response, responseData, success in
            //completion()
            if response["error"] as? String == "" || response["error"] as? String == nil{
                let dnsArray = try? JSONDecoder().decode([DNSModel].self, from: responseData ?? Data())
                self.ipListArray = dnsArray?.filter({$0.type?.lowercased() == ipType.ip.rawValue})
                self.dnsListArray = dnsArray?.filter({$0.type?.lowercased() == ipType.dns.rawValue})
                completion(true,"")
            }else{
                completion(false, response["error"] as? String ?? "")
            }
        }
    }
    
}

//MARK: GET IP LIST DETAIL
extension DNSViewModel{
    
    func getIpListCount()->Int{
        return ipListArray?.count ?? 0
    }
    
    func getIPListDetail(indexPath:IndexPath)->DnsDetailTuppleKeys{
        //guard ipListArray?.count ?? 0 > indexPath.row else {return  DnsDetailTuppleKeys()}
        let obj = ipListArray?[indexPath.row]
        return DnsDetailTuppleKeys(ip: obj?.ip ?? "",
                                   country_name: obj?.country_name ?? "",
                                   country: obj?.country?.uppercased() ?? "",
                                   asn: obj?.asn ?? "")
    }
    
   
    func getDnsListCount()->Int{
        return dnsListArray?.count ?? 0
    }
    
    func getDnsListDetail(indexPath:IndexPath)->DnsDetailTuppleKeys{
      //  guard dnsListArray?.count ?? 0 > indexPath.row else {return  DnsDetailTuppleKeys()}
        let obj = dnsListArray?[indexPath.row]
        return DnsDetailTuppleKeys(ip: obj?.ip ?? "",
                                   country_name: obj?.country_name ?? "",
                                   country: obj?.country?.uppercased() ?? "",
                                   asn: obj?.asn ?? "")
    }
}
