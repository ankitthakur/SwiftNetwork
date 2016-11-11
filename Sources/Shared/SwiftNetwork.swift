//
//  SwiftNetwork.swift
//  SwiftNetwork
//
//  Created by Ankit Thakur on 8/2/16.
//  Copyright © 2016 Ankit Thakur. All rights reserved.
//

import Foundation

/** SwiftNetwork Class
 
 */
public class SwiftNetwork:NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    open static let sharedInstance = SwiftNetwork()
    
    fileprivate var networkParams:Array<NetworkParams> = Array()
    
    fileprivate override init(){
        super.init()
    }
    
    internal class func addJSONHeaders( _ request:URLRequest) -> URLRequest{
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    
    
    fileprivate func networkCall(_ request:URLRequest, completionBlock:@escaping HTTPNetworkManagerCompletionBlock)
    {
        let configurationId = String(format: "SwiftNetwork%d", UInt32(self.networkParams.count)*arc4random())
        let configuration = URLSessionConfiguration.background(withIdentifier: configurationId)
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.current)
        let task = session.dataTask(with: request)
        
        task.resume()
        
        let param = NetworkParams()
        param.session = session
        param.completionBlock = completionBlock
        param.request = request
        networkParams[networkParams.count] = param
    }
    
    fileprivate func post(_ postData:Data, request:URLRequest, completionBlock:@escaping HTTPNetworkManagerCompletionBlock)
    {
        var request = request
        request.httpBody = postData as Data
        request.httpMethod = "POST"
        
        networkCall(request, completionBlock: completionBlock)
    }
    
    fileprivate func get(_ request:URLRequest, completionBlock:@escaping HTTPNetworkManagerCompletionBlock)
    {
        var request = request
        request.httpMethod = "GET"
        
        networkCall(request, completionBlock: completionBlock)
    }
    
    // MARK: Public APIs
    
    func get(_ urlSring:String, timeout:TimeInterval,completionBlock:@escaping HTTPNetworkManagerCompletionBlock)
    {
        let url = URL(string: urlSring)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
        request.httpMethod = "GET"
        request = SwiftNetwork.addJSONHeaders(request)
        
        networkCall(request, completionBlock: completionBlock)
    }
    
    func get(_ urlSring:String, headers:[String:String], timeout:TimeInterval, completionBlock:@escaping HTTPNetworkManagerCompletionBlock){
        let url = URL(string: urlSring)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
        request = SwiftNetwork.addJSONHeaders(request)
        
        for key in headers.keys {
            request.setValue(headers[key], forHTTPHeaderField: key)
        }
        
        get(request, completionBlock: completionBlock)
    }
    
    func post(_ urlSring:String, body:Data, timeout:TimeInterval, completionBlock:@escaping HTTPNetworkManagerCompletionBlock){
        let url = URL(string: urlSring)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
        request = SwiftNetwork.addJSONHeaders(request)
        post(body, request: request, completionBlock: completionBlock)
    }
    
    func post(_ urlSring:String, body:Data, headers:[String:String], timeout:TimeInterval, completionBlock:@escaping HTTPNetworkManagerCompletionBlock){
        let url = URL(string: urlSring)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
        request = SwiftNetwork.addJSONHeaders(request)
        
        for key in headers.keys {
            request.setValue(headers[key], forHTTPHeaderField: key)
        }
        
        post(body, request: request, completionBlock: completionBlock)
    }
    
    // MARK: Delegates
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        
        var disposition: URLSession.AuthChallengeDisposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        
        var credential:URLCredential?
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            
            //TODO: validate ssl pinning
            /*
            if (isValid != nil) {
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
                
                if (credential != nil) {
                    disposition = URLSession.AuthChallengeDisposition.useCredential
                }
                else{
                    disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
                }
            }
            else{
                disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
            }
            */
            credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
            if (credential != nil) {
                disposition = URLSession.AuthChallengeDisposition.useCredential
            }
            else{
                disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
            }
        }
        else{
            disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
        }
        
        
        completionHandler(disposition, credential)
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        
        var disposition: URLSession.AuthChallengeDisposition = URLSession.AuthChallengeDisposition.performDefaultHandling
        
        var credential:URLCredential?
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            
            //TODO: validate ssl pinning
            /*
             if (isValid != nil) {
                 credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
             
             if (credential != nil) {
                 disposition = URLSession.AuthChallengeDisposition.useCredential
             }
             else{
                 disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
             }
             }
             else{
                 disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
             }
             */
            credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            
            if (credential != nil) {
                disposition = URLSession.AuthChallengeDisposition.useCredential
            }
            else{
                disposition = URLSession.AuthChallengeDisposition.performDefaultHandling
            }
        }
        else{
            disposition = URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge
        }
        
        
        completionHandler(disposition, credential)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        
        let params = networkParams.filter {
            $0.session == session
        }
        
        if params.count > 0 {
            let param:NetworkParams? = params.last! as NetworkParams
            
            if (param != nil){
                param!.completionBlock!(nil, task.response, error as NSError?)
            }
        }
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void){
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        
        let params = networkParams.filter {
            $0.session == session
        }
        
        if params.count > 0 {
            let param:NetworkParams? = params.last! as NetworkParams
            
            if (param != nil){
                if param!.responseData == nil {
                    param!.responseData = NSMutableData(capacity: 0)
                }
                
                param!.responseData?.append(data)
            }
        }
        
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask){
        
        let responseStatusCode = (dataTask.response as! HTTPURLResponse).statusCode
        
        let params = networkParams.filter {
            $0.session == session
        }
        
        if params.count > 0 {
            let param:NetworkParams? = params.last! as NetworkParams
            
            if (param != nil){
                if (responseStatusCode >= 200 && responseStatusCode < 300) {
                    param!.completionBlock!(param!.responseData, dataTask.response, dataTask.error as NSError?);
                } else {
                    
                    param!.completionBlock!(nil, dataTask.response, dataTask.error as NSError?);
                }
            }
        }
        
        
    }
    
    
    
    
}
