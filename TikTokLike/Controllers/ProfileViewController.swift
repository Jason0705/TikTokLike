//
//  ProfileViewController.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Constants & Variables
    let defaults = UserDefaults.standard
    
    var from = 0 // from tab controll(self profile), 1: from profile selection(other's profile)
    var uid = UserService.getCurrentUserID()
    var user = User()
    
    // for header
    var headerIndexPath = IndexPath()
    
    
    // MARK: - UIOutlets
    
    @IBOutlet weak var addUserBarButton: UIBarButtonItem!
    @IBOutlet weak var moreBarButton: UIBarButtonItem!
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    
    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register xib
        profileCollectionView.register(UINib(nibName: "ProfileHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "profileHeaderView")
        
        profileCollectionView.register(UINib(nibName: "PostCollectionCell", bundle: nil), forCellWithReuseIdentifier: "postCollectionCell")

        setUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        defaults.set(4, forKey: "SelectedTabBar") // set last selected tab to 4
    }
    
    
    // MARK: Functions
    
    // UI Set Up
    func setUp() {
        if from == 0 { // from tab control, self profile
            self.navigationItem.rightBarButtonItem = moreBarButton
            self.navigationItem.leftBarButtonItem = addUserBarButton
        }
        else if from == 1 { // from profile selection, other's profile
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = nil
        }
        
        fetchUser()
        
        UserService.getUserOnce(with: uid) { (user, error) in
            if error != nil {
                print("Get User Error: \(error)")
            }
            else if user != nil {
                self.navigationItem.title = user!.user_name // change navbar title to userName
            }
        }
        
        profileCollectionView.collectionViewLayout = UIService.threeCellPerRowStyle(view: self.view, lineSpacing: 2, itemSpacing: 2, inset: 0, heightMultiplier: 1)
    }
    
    
    // Fetch User With uid
    
    func fetchUser() {
        UserService.getUser(with: uid) { (user, error) in
            if error != nil {
                print(error!)
            }
                
            else if user != nil {
                self.user = user!
                
                self.profileCollectionView.reloadData()
            }
        }
    }
    
    
    
    
    // MARK: - UIActions
    
    @IBAction func addUserBarButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func moreBarButtonPressed(_ sender: UIBarButtonItem) {
    }
    

}


// MARK: UICollectionView Delegate & DataSource

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionCell", for: indexPath) as! PostCollectionCell
        
        return cell
    }
    
    
    
    // Header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader: // header
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeaderView", for: indexPath) as! ProfileHeaderView
            
            headerIndexPath = indexPath
            
            headerView.delegate = self
            
            if let userName = user.user_name {
                headerView.userNameLabel.text = userName
            }
            
            if from == 0 { // from tab control, viewing self profile
                headerView.editProfileButton.isHidden = false
                headerView.followButton.isHidden = true
                headerView.messageUnfollowStackView.isHidden = true
            }
            else if from == 1 { // from profile selection, viewing other's profile
                headerView.editProfileButton.isHidden = true
            }
            
            
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "profileHeaderView", for: headerIndexPath) as? ProfileHeaderView {
            
            let height = headerView.containerView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height // get header height
            
            return CGSize(width: collectionView.frame.width, height: height)
        }
        
        return CGSize(width: collectionView.frame.width, height: 1)
    }
    
}


// MARK: - ProfileHeaderView Protocol

extension ProfileViewController: ProfileHeaderViewProtocol {

    func editProfile() {
        performSegue(withIdentifier: "profileVCToEditProfileVC", sender: nil)
    }


}
