//
//  AddUserViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-20.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    // MARK: - Constants & Variables
    
    var users = [User]()
    
    var selectedIndexPath = IndexPath()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addUserTableView: UITableView!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Cell.xib
        addUserTableView.register(UINib(nibName: "UserTableCell", bundle: nil), forCellReuseIdentifier: "userTableCell")
        
        
        fetchUsers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addUserVCToProfileVC" {
            let destinationVC = segue.destination as! ProfileViewController
            
            destinationVC.from = 1
            
            if let uid = users[selectedIndexPath.row].uid {
                destinationVC.uid = uid
            }
        }
    }
    
    
    // MARK: - Functions
    
    func fetchUsers() {
        UserService.getUsersExceptSelf { (users, error) in
            if error != nil {
                print(error)
            }
            else if users != nil {
                
                self.users = users!
                
                self.addUserTableView.reloadData()
            }
        }
    }
    
    func fetchUsers(keyword: String) {
        UserService.getUsersExceptSelf(keyword: keyword) { (users, error) in
            if error != nil {
                print(error)
            }
            else if users != nil {
                
                self.users = users!
                
                self.addUserTableView.reloadData()
            }
        }
    }
    

}


// MARK: UITableView Delegate & DataSource

extension AddUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTableCell", for: indexPath) as! UserTableCell
        
        if let profilePhotoURL = users[indexPath.row].profile_photo_url {
            cell.profileImageView.image = ImageService.getImageUsingCacheWithURL(urlString: profilePhotoURL)
        }
        
        if let userName = users[indexPath.row].user_name {
            cell.userNameLabel.text = userName
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndexPath = indexPath
        
        performSegue(withIdentifier: "addUserVCToProfileVC", sender: self)
    }
    
}


// MARK: - UISearchBar Delegate

extension AddUserViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            let searchInput = searchBar.text!.lowercased()
            fetchUsers(keyword: searchInput)
        }
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        fetchUsers()
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetchUsers()
        }
    }
    
}
