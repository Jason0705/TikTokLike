//
//  SignInViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignInViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var toSignUpButton: UIButton!
    
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AuthService.autoSignIn()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // remove keyboard
    }
    
    
    // MARK: - Functions
    
    // UI Set Up
    func setUp() {
        signInButton.isEnabled = false // disable signUpButton
        textFieldsUnderline() // add underlines to textFields
        checkTextFields() // check textFields are filled
    }
    
    // Text Fields Underline Style
    func textFieldsUnderline() {
        UIService.textFieldUnderline(textField: emailTextField)
        UIService.textFieldUnderline(textField: passwordTextField)
    }
    
    // Checking Text Fields Format, Add textFieldDidChange() to Text Fields
    func checkTextFields() {
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    // Check Text Fields When Changed
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signInButton.isEnabled = false // disable signInButton if any of email, password text fields is empty.
            return
        }
        signInButton.isEnabled = true // enable signInButton if all of email, password text fields are not empty.
    }
    
    
    // MARK: - IBActions
    
    // Press signInButton
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        view.endEditing(true) // remove keyboard
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show() // show loading
        
        // Sign in user using email and password input.
        AuthService.signInUser(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: { // successfully signed in
            SVProgressHUD.dismiss() // dismiss loading
            self.performSegue(withIdentifier: "signInVCToMainTBC", sender: nil) // segue to MainTBC
        }, onFail: { (error) in // failed signing in
            SVProgressHUD.dismiss() // dismiss loading
            AlertService.alertService.presentErrorAlert(message: error!, vc: self) // present alert with failling error
        })
    }
    

}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField { // try to find next responder.
            nextField.becomeFirstResponder() // found, start editing found text field.
        } else {
            textField.resignFirstResponder() // not found, remove keyboard.
        }
        
        return false
    }
    
}
