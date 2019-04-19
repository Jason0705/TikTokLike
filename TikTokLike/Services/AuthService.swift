//
//  AuthService.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class AuthService {
    
    // Sign In User
    static func signInUser(email: String, password: String, onSuccess: @escaping() -> Void, onFail: @escaping(_ errorMessage: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in // sign in with email and password
            if error != nil { // if there's an error
                onFail(error!.localizedDescription) // get error
                return
            }
            onSuccess() // successfully signed in
        }
    }
    
    // Sign Up User
    static func signUpUser(email: String, password: String, onSuccess: @escaping() -> Void, onFail: @escaping(_ errorMessage: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in // sign up user with email and password
            if error != nil { // if there's an error
                onFail(error!.localizedDescription) // get error
                return
            }
            guard let user = authResult?.user else { return } // get successfully created user
            let uid = user.uid
            self.setUserInfo(email: email, uid: uid, onSuccess: onSuccess)
        }
    }
    
    
    // First time set up user
    static func setUserInfo(email: String, uid: String, onSuccess: @escaping() -> Void) {
        let databaseReference = Database.database().reference()
        let usersReference = databaseReference.child("users")
        let newUserReference = usersReference.child(uid)
        
        let emailComponents = email.components(separatedBy: "@") // seperate email by "@" ie: seperate "example@gmail.com" into ["example", "gamil.com"]
        let userName = emailComponents[0] // set userName to emailComponents at index 0 ie: "example"
        
        newUserReference.setValue(["email": email,
                                   "uid": uid,
                                   "user_name": userName]) // set values of email, uid, user_name to new user
        
        onSuccess()
    }
    
    
    // Auto Sign In
    static func autoSignIn() {
        if Auth.auth().currentUser != nil {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = mainStoryboard.instantiateViewController(withIdentifier: "MainTBC") as! UITabBarController
            UIApplication.shared.keyWindow?.rootViewController = tabBarController
        }
    }
    
}
