//
//  CameraViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    
    // MARK: - Constants & Variables
    let defaults = UserDefaults.standard
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func testBarButtonPressed(_ sender: UIBarButtonItem) {
        self.tabBarController?.selectedIndex = self.defaults.integer(forKey: "SelectedTabBar")
    }
    

}
