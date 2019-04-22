//
//  SearchViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchViewController: UIViewController {

    
    // MARK: - Constants & Variables
    let defaults = UserDefaults.standard
    
    var posts = [Post]()
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Xib
        searchCollectionView.register(UINib(nibName: "PostCollectionCell", bundle: nil), forCellWithReuseIdentifier: "postCollectionCell")
        
        setUp()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.set(1, forKey: "SelectedTabBar") // set last selected tab to 1
    }
    
    
    // MARK: - Functions
    
    func setUp() {
        
        fetchPosts()
        
        searchCollectionView.collectionViewLayout = UIService.threeCellPerRowStyle(view: self.view, lineSpacing: 2, itemSpacing: 2, inset: 0, heightMultiplier: 1)
    }
    
    
    func fetchPosts() {
        PostService.fetchOthersPosts { (posts, error) in
            if error != nil {
                print(error)
            }
            else if posts != nil {
                self.posts = posts!.reversed()
                
                self.searchCollectionView.reloadData()
            }
        }
    }
    
    func fetchPosts(keyword: String) {
        PostService.fetchOthersPosts(keyword: keyword) { (posts, error) in
            if error != nil {
                print(error)
            }
            else if posts != nil {
                self.posts = posts!.reversed()
                
                self.searchCollectionView.reloadData()
            }
        }
    }
    
    
    
    // MARK: - IBActions
    

}


// MARK: - UICollectionView Delegate & DataSource

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionCell", for: indexPath) as! PostCollectionCell
        
        if let thumbnailURL = posts[indexPath.row].thumbnail_url {
            cell.postImageView.image = ImageService.getImageUsingCacheWithURL(urlString: thumbnailURL)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Post", bundle: nil)
        let postVC = storyboard.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        
        postVC.post = posts[indexPath.row]
        
        self.present(postVC, animated: true, completion: nil)
    }
    
    
    
}


// MARK: - UISearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            let searchInput = searchBar.text!.lowercased()
            fetchPosts(keyword: searchInput)
        }
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        fetchPosts()
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetchPosts()
        }
    }
    
}
