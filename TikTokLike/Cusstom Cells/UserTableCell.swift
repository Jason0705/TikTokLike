//
//  UserTableCell.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-20.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class UserTableCell: UITableViewCell {

    
    // MARK: - IBOutlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = 0.5 * profileImageView.frame.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
