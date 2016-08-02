// SwiftNetwork iOS Playground

import UIKit
import SwiftNetwork

var str = "Hello, playground"


SwiftNetwork.sharedInstance.get("http://www.google.com", timeout: 60) { (data, response, error) -> (Void) in
    print(data)
    print(response)
    print(error)
}

SwiftNetwork.sharedInstance.get(<#T##urlSring: String##String#>, timeout: <#T##TimeInterval#>, completionBlock: <#T##HTTPNetworkManagerCompletionBlock##HTTPNetworkManagerCompletionBlock##(data: NSMutableData?, response: URLResponse?, error: NSError?) -> (Void)#>)

SwiftNetwork.sharedInstance.get(<#T##urlSring: String##String#>, headers: <#T##[String : String]#>, timeout: <#T##TimeInterval#>, completionBlock: <#T##HTTPNetworkManagerCompletionBlock##HTTPNetworkManagerCompletionBlock##(data: NSMutableData?, response: URLResponse?, error: NSError?) -> (Void)#>)

SwiftNetwork.sharedInstance.post(<#T##urlSring: String##String#>, body: <#T##Data#>, timeout: <#T##TimeInterval#>, completionBlock: <#T##HTTPNetworkManagerCompletionBlock##HTTPNetworkManagerCompletionBlock##(data: NSMutableData?, response: URLResponse?, error: NSError?) -> (Void)#>)

SwiftNetwork.sharedInstance.post(<#T##urlSring: String##String#>, body: <#T##Data#>, headers: <#T##[String : String]#>, timeout: <#T##TimeInterval#>, completionBlock: <#T##HTTPNetworkManagerCompletionBlock##HTTPNetworkManagerCompletionBlock##(data: NSMutableData?, response: URLResponse?, error: NSError?) -> (Void)#>)