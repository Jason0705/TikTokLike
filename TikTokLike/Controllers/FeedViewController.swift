//
//  FeedViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class FeedViewController: UIViewController {

    
    // MARK: - Constants & Variables
    let defaults = UserDefaults.standard
    
    let baseURL = URL(string: "https://livestreamfails.com/")
    
    var webPosts = [WebPost]()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var feedTableView: UITableView!
    
    @IBOutlet weak var feedWebView: UIWebView!
    
    // MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Cell.xib
        feedTableView.register(UINib(nibName: "FeedTableCell", bundle: nil), forCellReuseIdentifier: "feedTableCell")
        
        fetchWebPosts()
        
        feedWebView.loadRequest(URLRequest(url: baseURL!))
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.set(0, forKey: "SelectedTabBar") // set last selected tab to 0
        
        
    }
    
    
    // MARK: Functions

    func fetchWebPosts() {
        
        webPosts = WebPostService.getWebPosts()
        feedTableView.reloadData()
        
    }
    
    
}


// MARK: - UITableView Delegate & DataSource

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedTableCell", for: indexPath) as! FeedTableCell
        
        if let title = webPosts[indexPath.row].title {
            cell.titleTextView.text = title
        }
        
        if let thumbnailURL = webPosts[indexPath.row].thumbnailURL {
            cell.thumbnailImageView.image = ImageService.getImageUsingCacheWithURL(urlString: thumbnailURL)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return feedTableView.frame.height
        return feedTableView.frame.height / 3
    }
    
    
}


