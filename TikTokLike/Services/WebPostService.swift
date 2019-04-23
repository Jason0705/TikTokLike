//
//  WebPostService.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-22.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import Foundation

class WebPostService {
    
    
    static func getWebPosts() -> [WebPost] {
        
        let baseURLString = "https://livestreamfails.com/post/"
        
        var webPosts = [WebPost]()
        
        for i in 47905...47908 { // post 47850 to post 47905 on livestreamfails
            let postURLString = baseURLString + "\(i)"
            
            guard let postURL = URL(string: postURLString) else {
                print("Error: \(postURLString) doesn't seem to be a valid URL")
                return [WebPost]()
            }
            
            do {
                let postHTMLString = try String(contentsOf: postURL, encoding: .ascii)
                
                let webPost = WebPost()
                
                if let titleMatch = postHTMLString.range(of: "(?<=<meta property=\"og:title\" content=\")[^\"]+", options: .regularExpression) {
                    webPost.title = postHTMLString.substring(with: titleMatch)
                }
                
                if let thumbnailURLMatch = postHTMLString.range(of: "(?<=<meta property=\"og:image\" content=\")[^\"]+", options: .regularExpression) {
                    webPost.thumbnailURL = postHTMLString.substring(with: thumbnailURLMatch)
                }
                
                if let videoURLMatch = postHTMLString.range(of: "(?<=<meta property=\"og:video\" content=\")[^\"]+", options: .regularExpression) {
                    webPost.videoURL = postHTMLString.substring(with: videoURLMatch)
                }
                
                webPosts.append(webPost)
                
            } catch let error {
                print("Error: \(error)")
            }
        }
        
        return webPosts
        
    }
    
    
}
