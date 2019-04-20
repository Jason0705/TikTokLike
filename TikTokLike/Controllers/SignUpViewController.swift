//
//  SignUpViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignUpViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var toSignInButton: UIButton!
    
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        setUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) // remove keyboard
    }
    
    
    // MARK: - Functions
    
    // UI Set Up
    func setUp() {
        signUpButton.isEnabled = false // disable signUpButton
        textFieldsUnderline() // add underlines to textFields
        checkTextFields() // check textFields are filled
    }
    
    // Text Fields Underline Style
    func textFieldsUnderline() {
        UIService.textFieldUnderline(textField: emailTextField)
        UIService.textFieldUnderline(textField: passwordTextField)
        UIService.textFieldUnderline(textField: confirmPasswordTextField)
    }
    
    // Checking Text Fields Format, Add textFieldDidChange() to Text Fields
    func checkTextFields() {
        emailTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(SignUpViewController.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    // Check Text Fields When Changed
    @objc func textFieldDidChange() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty, let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            signUpButton.isEnabled = false // disable signUpButton if any of email, password, confirmPassword text fields is empty.
            return
        }
        signUpButton.isEnabled = true // enable signUpButton if all of email, password, confirmPassword text fields are not empty.
    }
    
    

    // Mark: - IBActions
    
    // Press signUpButton
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        view.endEditing(true) // remove keyboard
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show() // show loading
        
        // Sign up user using email and password input.
        if passwordTextField.text != confirmPasswordTextField.text { // if password is not the same as confirmPassword.
            SVProgressHUD.dismiss() // remove loading
            AlertService.alertService.presentErrorAlert(message: "Password does not match the confirm password! Please check again.", vc: self) // present allert to show error
            return
        }
        AuthService.signUpUser(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: { // successfully signed up user
            SVProgressHUD.dismiss() // remove loading
            self.performSegue(withIdentifier: "signUpVCToMainTBC", sender: nil) // segue to MainTBC
        }, onFail: { (error) in // failed signing up user
            SVProgressHUD.dismiss() // remove loading
            AlertService.alertService.presentErrorAlert(message: error!, vc: self) // present error with failling error
        })
    }
    
    // Press toSignInButton
    @IBAction func toSignInButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil) // dismiss, go back to signInVC
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField { // try to find next responder.
            nextField.becomeFirstResponder() // found, start editing found text field.
        } else {
            textField.resignFirstResponder() // not found, remove keyboard.
        }
        
        return false
    }
    
}
