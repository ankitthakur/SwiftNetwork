import UIKit
import SwiftNetwork

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white()
    
    SwiftNetwork.sharedInstance.get("http://www.google.com", timeout: 60) { (data, response, error) -> (Void) in
        print(data)
        print(response)
        print(error)
    }

  }
}

