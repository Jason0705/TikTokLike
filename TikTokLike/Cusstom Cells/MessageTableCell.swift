//
//  MessageTableCell.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-22.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class MessageTableCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var senderProfileImageView: UIImageView!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var senderUserNameLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        senderProfileImageView.layer.cornerRadius = 0.5 * senderProfileImageView.frame.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
