//
//  FeedTableCell.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-22.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class FeedTableCell: UITableViewCell {

    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
