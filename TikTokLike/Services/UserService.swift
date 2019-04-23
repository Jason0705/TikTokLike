//
//  UserService.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class UserService {
    
    // Get current user uid
    static func getCurrentUserID() -> String {
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            
            return uid
        }
        
        return ""
    }
    
    // Get user once
    static func getUserOnce(with uid: String, completion: @escaping (User?, Error?) -> Void) {
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let user = User()
                
                user.uid = dictionary["uid"] as? String
                user.email = dictionary["email"] as? String
                
                user.profile_photo_url = dictionary["profile_photo_url"] as? String
                
                user.user_name = dictionary["user_name"] as? String
                user.bio = dictionary["bio"] as? String
                
                user.followings = dictionary["followings"] as? [String]
                user.followers = dictionary["followers"] as? [String]
                
                completion(user, nil)
            }
        }, withCancel: { (error) in
            completion(nil, error)
        })
    }
    
    
    
    static func getUser(with uid: String, completion: @escaping (User?, Error?) -> Void) {
        
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let user = User()
                
                user.uid = dictionary["uid"] as? String
                user.email = dictionary["email"] as? String
                
                user.profile_photo_url = dictionary["profile_photo_url"] as? String
                
                user.user_name = dictionary["user_name"] as? String
                user.bio = dictionary["bio"] as? String
                
                user.followings = dictionary["followings"] as? [String]
                user.followers = dictionary["followers"] as? [String]
                
                completion(user, nil)
            }
        }, withCancel: { (error) in
            completion(nil, error)
        })
    }
    
    
    static func getUsersExceptSelf(completion: @escaping ([User]?, Error?) -> Void) {
        
        var users = [User]()
        
        SVProgressHUD.show()
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                
                user.uid = dictionary["uid"] as? String
                user.email = dictionary["email"] as? String
                
                user.profile_photo_url = dictionary["profile_photo_url"] as? String
                
                user.user_name = dictionary["user_name"] as? String
                user.bio = dictionary["bio"] as? String
                
                user.followings = dictionary["followings"] as? [String]
                user.followers = dictionary["followers"] as? [String]
                
                if let uid = user.uid {
                    if uid != UserService.getCurrentUserID() {
                        users.append(user)
                    }
                }
            }
            
            SVProgressHUD.dismiss()
            completion(users, nil)
            
            
        }) { (error) in
            SVProgressHUD.dismiss()
            completion(nil, error)
        }
        
        SVProgressHUD.dismiss()
        
    }
    
    
    
    static func getUsersExceptSelf(keyword: String, completion: @escaping ([User]?, Error?) -> Void) {
        
        var users = [User]()
        
        SVProgressHUD.show()
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                
                user.uid = dictionary["uid"] as? String
                user.email = dictionary["email"] as? String
                
                user.profile_photo_url = dictionary["profile_photo_url"] as? String
                
                user.user_name = dictionary["user_name"] as? String
                user.bio = dictionary["bio"] as? String
                
                user.followings = dictionary["followings"] as? [String]
                user.followers = dictionary["followers"] as? [String]
                
                if let uid = user.uid {
                    if uid != UserService.getCurrentUserID() {
                        if user.email == keyword || user.user_name!.contains(keyword) {
                            users.append(user)
                        }
                    }
                }
            }
            
            SVProgressHUD.dismiss()
            completion(users, nil)
            
            
        }) { (error) in
            SVProgressHUD.dismiss()
            completion(nil, error)
        }
        
        SVProgressHUD.dismiss()
        
        
    }
    
}
