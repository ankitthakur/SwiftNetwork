# SwiftNetwork

[![CI Status](http://img.shields.io/travis/ankitthakur/SwiftNetwork.svg?style=flat)](https://travis-ci.org/ankitthakur/SwiftNetwork)
[![Version](https://img.shields.io/cocoapods/v/SwiftNetwork.svg?style=flat)](http://cocoadocs.org/docsets/SwiftNetwork)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/SwiftNetwork.svg?style=flat)](http://cocoadocs.org/docsets/SwiftNetwork)
[![Platform](https://img.shields.io/cocoapods/p/SwiftNetwork.svg?style=flat)](http://cocoadocs.org/docsets/SwiftNetwork)

## Description

**SwiftNetwork** is lightweight network layer in swift.

## Usage

```swift
HTTPNetworkManagerCompletionBlock = (data:NSMutableData?, response:URLResponse?, error:NSError?) -> (Void)

SwiftNetwork.sharedInstance.get(<#T##urlSring: String##String#>, timeout: <#T##TimeInterval#>, completionBlock: <#T##HTTPNetworkManagerCompletionBlock##HTTPNetworkManagerCompletionBlock##(data: NSMutableData?, response: URLResponse?, error: NSError?) -> (Void)#>)

SwiftNetwork.sharedInstance.get(<#T##urlSring: String##String#>, headers: <#T##[String : String]#>, timeout: <#T##TimeInterval#>, completionBlock: <#T##HTTPNetworkManagerCompletionBlock##HTTPNetworkManagerCompletionBlock##(data: NSMutableData?, response: URLResponse?, error: NSError?) -> (Void)#>)

SwiftNetwork.sharedInstance.post(<#T##urlSring: String##String#>, body: <#T##Data#>, timeout: <#T##TimeInterval#>, completionBlock: <#T##HTTPNetworkManagerCompletionBlock##HTTPNetworkManagerCompletionBlock##(data: NSMutableData?, response: URLResponse?, error: NSError?) -> (Void)#>)

SwiftNetwork.sharedInstance.post(<#T##urlSring: String##String#>, body: <#T##Data#>, headers: <#T##[String : String]#>, timeout: <#T##TimeInterval#>, completionBlock: <#T##HTTPNetworkManagerCompletionBlock##HTTPNetworkManagerCompletionBlock##(data: NSMutableData?, response: URLResponse?, error: NSError?) -> (Void)#>)


```

## Installation

**SwiftNetwork** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftNetwork'
```

**SwiftNetwork** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "ankitthakur/SwiftNetwork"
```

**SwiftNetwork** can also be installed manually. Just download and drop `Sources` folders in your project.

## Author

Ankit Thakur, ankitthakur85@icloud.com

## Contributing

We would love you to contribute to **SwiftNetwork**, check the [CONTRIBUTING](https://github.com/ankitthakur/SwiftNetwork/blob/master/CONTRIBUTING.md) file for more info.

## License

**SwiftNetwork** is available under the MIT license. See the [LICENSE](https://github.com/ankitthakur/SwiftNetwork/blob/master/LICENSE.md) file for more info.
