//
//  DNSModel.swift
//  DNS
//
//  Created by Ajay on 30/07/23.
//

import Foundation

struct DNSModel : Codable {
    var error : String?
    var ip : String?
    var country : String?
    var country_name : String?
    var asn : String?
    var type : String?

    enum CodingKeys: String, CodingKey {

        case ip = "ip"
        case country = "country"
        case country_name = "country_name"
        case asn = "asn"
        case type = "type"
        case error
    }

    init(from decoder: Decoder) throws {
        do{
            let values = try decoder.container(keyedBy: CodingKeys.self)
            error = try values.decodeIfPresent(String.self, forKey: .error)
            ip = try values.decodeIfPresent(String.self, forKey: .ip)
            country = try values.decodeIfPresent(String.self, forKey: .country)
            country_name = try values.decodeIfPresent(String.self, forKey: .country_name)
            asn = try values.decodeIfPresent(String.self, forKey: .asn)
            type = try values.decodeIfPresent(String.self, forKey: .type)
        }catch{
            Logger.log(("error misType:- \(error)"))
        }
    }

}
