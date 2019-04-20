//
//  SideMenuViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class MenuViewController: UIViewController {

    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    // MARK: - IBActions

    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
            self.present(signInVC, animated: true, completion: nil)
            
        } catch let logOutError {
            print(logOutError)
            SVProgressHUD.showError(withStatus: "Sorry, please try again later.")
        }
    }
    
    
}
