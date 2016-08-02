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

    public static let sharedInstance = SwiftNetwork()
    
    private var networkParams:Array<NetworkParams> = Array()

    private override init(){
        super.init()
    }
    
    internal class func addJSONHeaders( _ request:URLRequest) -> URLRequest{
        var request = request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    
    
    private func networkCall(_ request:URLRequest, completionBlock:HTTPNetworkManagerCompletionBlock)
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
    
    private func post(_ postData:Data, request:URLRequest, completionBlock:HTTPNetworkManagerCompletionBlock)
    {
        var request = request
        request.httpBody = postData as Data
        request.httpMethod = "POST"
        
        networkCall(request, completionBlock: completionBlock)
    }
    
    private func get(_ request:URLRequest, completionBlock:HTTPNetworkManagerCompletionBlock)
    {
        var request = request
        request.httpMethod = "GET"
        
        networkCall(request, completionBlock: completionBlock)
    }
    
    // MARK: Public APIs
    
    public func get(_ urlSring:String, timeout:TimeInterval,completionBlock:HTTPNetworkManagerCompletionBlock)
    {
        let url = URL(string: urlSring)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
        request.httpMethod = "GET"
        request = SwiftNetwork.addJSONHeaders(request)
        
        networkCall(request, completionBlock: completionBlock)
    }
   
    public func get(_ urlSring:String, headers:[String:String], timeout:TimeInterval, completionBlock:HTTPNetworkManagerCompletionBlock){
        let url = URL(string: urlSring)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
        request = SwiftNetwork.addJSONHeaders(request)
        
        for key in headers.keys {
            request.setValue(headers[key], forHTTPHeaderField: key)
        }
        
        get(request, completionBlock: completionBlock)
    }
    
    public func post(_ urlSring:String, body:Data, timeout:TimeInterval, completionBlock:HTTPNetworkManagerCompletionBlock){
        let url = URL(string: urlSring)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
        request = SwiftNetwork.addJSONHeaders(request)
        post(body, request: request, completionBlock: completionBlock)
    }
    
    public func post(_ urlSring:String, body:Data, headers:[String:String], timeout:TimeInterval, completionBlock:HTTPNetworkManagerCompletionBlock){
        let url = URL(string: urlSring)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: timeout)
        request = SwiftNetwork.addJSONHeaders(request)
        
        for key in headers.keys {
            request.setValue(headers[key], forHTTPHeaderField: key)
        }
        
        post(body, request: request, completionBlock: completionBlock)
    }
    
    // MARK: Delegates
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void){
        
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: NSError?){
        
        let params = networkParams.filter {
            $0.session == session
        }
        
        guard let param:NetworkParams = params.last! as NetworkParams else{return}
        
        param.completionBlock!(data:nil, response:task.response, error:error)
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (URLSession.ResponseDisposition) -> Swift.Void){
        
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data){
        
        let params = networkParams.filter {
            $0.session == session
        }
        
        guard let param:NetworkParams = params.last! as NetworkParams else{
            return
        }
        
        if param.responseData == nil {
            param.responseData = NSMutableData(capacity: 0)
        }
        
        param.responseData?.append(data)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask){
        
        let responseStatusCode = (dataTask.response as! HTTPURLResponse).statusCode
        
        let params = networkParams.filter {
            $0.session == session
        }
        
        guard let param:NetworkParams = params.last! as NetworkParams else{
            return
        }
        
        if (responseStatusCode >= 200 && responseStatusCode < 300) {
            param.completionBlock!(data: param.responseData, response: dataTask.response, error: dataTask.error);
        } else {
            
            param.completionBlock!(data: nil, response: dataTask.response, error: dataTask.error);
        }
    }
    
    
    

}
