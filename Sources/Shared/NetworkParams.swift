//
//  NetworkParams.swift
//  SwiftNetwork
//
//  Created by Ankit Thakur on 8/2/16.
//  Copyright © 2016 Ankit Thakur. All rights reserved.
//

import Foundation

/** NetworkParams Class
 This class act as a model, containing all required info for single request.
*/

public typealias HTTPNetworkManagerCompletionBlock = (_ data:NSMutableData?, _ response:URLResponse?, _ error:NSError?) -> (Void)

open class NetworkParams {

    /**
     *  nsurlconnection object
     */
    var session:URLSession?
    
    var task:URLSessionTask?
    
    /**
     *  request, for which the connection is made
     */
    var request:URLRequest?
    /**
     *  success block, when the server status is SUCCESS/200
     */
    var completionBlock:HTTPNetworkManagerCompletionBlock?
    
    /**
     *  responseData is binary data, when status is SUCCESS/200
     */
    var responseData:NSMutableData?;
    
}
