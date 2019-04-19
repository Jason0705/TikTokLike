//
//  AlertService.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class AlertService: UIViewController {
    
    static var alertService = AlertService()
    
    // Present Error Alert
    func presentErrorAlert(message: String, vc: UIViewController) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (AlertAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        vc.present(alert, animated: true, completion: nil)
    }
}
