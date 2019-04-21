//
//  CameraViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    
    // MARK: - Constants & Variables
    let defaults = UserDefaults.standard
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        openCamera()
        self.tabBarController?.selectedIndex = self.defaults.integer(forKey: "SelectedTabBar")
    }
    
    
    // MARK: - Functions
    
    func openCamera() {
        let storyboard = UIStoryboard(name: "CustomCamera", bundle: nil)
        let customCameraVC = storyboard.instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraViewController
        customCameraVC.from = 1
        customCameraVC.captureMode = 1
        self.present(customCameraVC, animated: true, completion: nil)
    }
    
    

}
