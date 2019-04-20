//
//  ProfileHeaderView.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {

    // MARK: - UIOutlets
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var videoCountLabel: UILabel!
    
    @IBOutlet weak var followStackView: UIStackView!
    @IBOutlet weak var followingStackView: UIStackView!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerStackView: UIStackView!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var messageUnfollowStackView: UIStackView!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var unfollowButton: UIButton!
    
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.frame.width
    }
    
}
