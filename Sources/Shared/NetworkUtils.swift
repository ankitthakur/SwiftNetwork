//
//  NetworkUtils.swift
//  SwiftNetwork
//
//  Created by Ankit Thakur on 8/2/16.
//  Copyright © 2016 Ankit Thakur. All rights reserved.
//

import Foundation

extension URLRequest {
    
    static func allowsAnyHTTPSCertificateForHost(_ host:String) -> Bool{
        return false
    }
}
