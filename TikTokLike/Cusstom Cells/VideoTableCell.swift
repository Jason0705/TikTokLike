//
//  VideoTableCell.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-20.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

protocol VideoTableCellProtocal {
    func audioOn()
    func audioOff()
}

class VideoTableCell: UITableViewCell {
    
    var delegate: VideoTableCellProtocal?
    
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var videoPreviewView: UIView!
    @IBOutlet weak var audioButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    }
    
    func audioControl() {
        if audioButton.tag == 0 { // audio off
            audioButton.tag = 1
            delegate?.audioOn()
            audioButton.setImage(UIImage(named: "audio_on"), for: .normal)
        }
        else if audioButton.tag == 1 { // aduio on
            audioButton.tag = 0
            delegate?.audioOff()
            audioButton.setImage(UIImage(named: "audio_off"), for: .normal)
        }
    }
    
    
    @IBAction func audioButtonPressed(_ sender: UIButton) {
        audioControl()
    }
    
}

