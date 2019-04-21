//
//  PostService.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-20.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class PostService {
    
    
    static func fetchPosts(with uid: String, completion: @escaping ([Post]?, Error?) -> Void) {
        
        var posts = [Post]()
        
        Database.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                let post = Post()
                
                post.video_url = dictionary["video_url"] as? String
                post.caption = dictionary["caption"] as? String
                post.post_id = dictionary["post_id"] as? String
                post.uid = dictionary["uid"] as? String
                post.timestamp = dictionary["timestamp"] as? [AnyHashable: Any]
                
                if post.uid != nil && post.uid == uid {
                    posts.append(post)
                }
                
            }
            
            completion(posts, nil)
            
        }) { (error) in
            completion(nil, error)
        }
        
    }
    
    
}
