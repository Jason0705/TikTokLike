//
//  FollowService.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-20.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import Foundation
import FirebaseDatabase


class FollowService {
    
    static var followings = [""]//[String]()
    static var followers = [""]//[String]()
    
    static func followUser(of uid: String) {
        let currentUserID = UserService.getCurrentUserID()
        let databaseReference = Database.database().reference()
        
        let currentUserReference = databaseReference.child("users").child(currentUserID)
        let userReference = databaseReference.child("users").child(uid)
        
        fetchFollowings(of: currentUserID)
        fetchFollowers(of: uid)
        
        appendFollower(uid: uid, to: &followings)
        appendFollower(uid: currentUserID, to: &followers)
        
        currentUserReference.child("followings").setValue(followings)
        userReference.child("followers").setValue(followers)
        
    }
    
    static func unfollowUser(of uid: String) {
        let currentUserID = UserService.getCurrentUserID()
        let databaseReference = Database.database().reference()
        
        let currentUserReference = databaseReference.child("users").child(currentUserID)
        let userReference = databaseReference.child("users").child(uid)
        
        fetchFollowings(of: currentUserID)
        fetchFollowers(of: uid)
        
        removeFollower(uid: uid, from: &followings)
        removeFollower(uid: currentUserID, from: &followers)
        
        currentUserReference.child("followings").setValue(followings)
        userReference.child("followers").setValue(followers)
    }
    
    static func fetchFollowings(of uid: String) {
        
        let databaseReference = Database.database().reference()
        let userReference = databaseReference.child("users").child(uid)
        
        userReference.child("followings").observeSingleEvent(of: .value, with: { (snapshot) in
            if let followings = snapshot.value as? [String] {
                self.followings = followings
            }
        }, withCancel: nil)
    }
    
    static func fetchFollowers(of uid: String) {
        
        let databaseReference = Database.database().reference()
        let userReference = databaseReference.child("users").child(uid)
        
        userReference.child("followers").observeSingleEvent(of: .value, with: { (snapshot) in
            if let followers = snapshot.value as? [String] {
                self.followers = followers
            }
        }, withCancel: nil)
    }
    
    static func appendFollower(uid: String, to array: inout [String]) {
        if !array.contains(uid) {
            array.append(uid)
        }
    }
    
    
    static func removeFollower(uid: String, from array: inout [String]) {
        array.removeAll{$0 == uid}
    }
    
    static func isFollowingUser(of uid: String) -> Bool {
        fetchFollowings(of: UserService.getCurrentUserID())
        
        var following = false
        
        if followings.contains(uid) {
            following = true
        }
        
        return following
        
    }
    
}
