//
//  ViewController.swift
//  Prouduct MVVM
//
//  Created by Ebraheem Alnaqer on 03/09/2023.
//

import UIKit

class ViewController: UITabBarController {

    //declare this property where it won't go out of scope relative to your listener
    let reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.reachability.whenReachable = { reachability in
                if reachability.connection == .wifi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
                self.view.window?.rootViewController?.dismiss(animated: true)
            }
            self.reachability.whenUnreachable = { _ in
                print("Not reachable")
                if let networkVc = self.storyboard?.instantiateViewController(withIdentifier: "NetworkErrorViewController") as? NetworkErrorViewsController{
                    self.present(networkVc, animated: true)
                }
            }

            do {
                try self.reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        }
        
    }
    
    deinit {
        reachability.stopNotifier()
    }

}
