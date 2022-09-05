//
//  APIRequest.swift
//  TheMarvels
//
//  Created by Surbhi Bagadia on 05/09/22.
//

import CommonCrypto
import Foundation

// Creates and encrpts parameters for an API request
struct APIRequest: Encodable {
    let ts: String = "\(Date().timeIntervalSince1970)".components(separatedBy: ".")[0]
    let apikey: String = "8aea06385d17ce44ee52d3ebcd124a69"
    var hash: String {
        var hashString = ""
        if let privateApiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
            let combination = ts+privateApiKey+apikey
            hashString = MD5(combination) ?? ""
        }
        return hashString
    }
    
    // Encryption for api request
    func MD5(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        if let d = string.data(using: .utf8) {
            _ = d.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
                return ""
            }
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
