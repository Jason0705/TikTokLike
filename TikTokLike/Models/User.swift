//
//  User.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import Foundation

class User: NSObject {
    var uid: String?
    var email: String?
    var user_name: String?
    var profile_photo_url: String?
    var followings: [String]?
    var followers: [String]?
}
