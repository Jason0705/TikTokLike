//
//  ChatsViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SocialViewController: UIViewController {

    
    // MARK: - Constants & Variables
    let defaults = UserDefaults.standard
    
    let selfUID = UserService.getCurrentUserID()
    
    var uids = [String]()
    var selectedIndexPath = IndexPath()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var socialTableView: UITableView!
    
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register Cell.xib
        socialTableView.register(UINib(nibName: "UserTableCell", bundle: nil), forCellReuseIdentifier: "userTableCell")

        
        fetchChatUIDs()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.set(3, forKey: "SelectedTabBar") // set last selected tab to 3
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "socialVCToChatVC" {
            let destinationVC = segue.destination as! ChatViewController
            
            destinationVC.uid = uids[selectedIndexPath.row]
        }
    }
    
    
    // MARK: - Functions
    
    func fetchChatUIDs() {
        Database.database().reference().child("messages").observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                if let sender = dictionary["sender"], let receiver = dictionary["receiver"] {
                    
                    if sender == self.selfUID && !self.uids.contains(receiver) {
                        self.uids.append(receiver)
                    }
                    
                    if receiver == self.selfUID && !self.uids.contains(sender) {
                        self.uids.append(sender)
                    }
                    
                    self.socialTableView.reloadData()
                }
            }
        }
    }


}


// MARK: - UITableView Delegate & DataSource

extension SocialViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTableCell", for: indexPath) as! UserTableCell
        
        UserService.getUserOnce(with: uids[indexPath.row]) { (user, error) in
            if error != nil {
                print(error)
            }
            else if user != nil {
                
                if let profileURL = user?.profile_photo_url{
                    cell.profileImageView.image = ImageService.getImageUsingCacheWithURL(urlString: profileURL)
                }
                if let userName = user?.user_name {
                    cell.userNameLabel.text = userName
                }
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "socialVCToChatVC", sender: self)
    }
    
}
