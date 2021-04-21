//
//  TabBarViewController.swift
//  Flavorful
//
//  Created by Slarve N. on 3/29/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Hide back button bar
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

}
