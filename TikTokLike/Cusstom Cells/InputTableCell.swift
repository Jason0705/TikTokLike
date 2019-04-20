//
//  InputTableCell.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

protocol InputTableCellProtocol {
    func cellContentReceived(content: String)
}

class InputTableCell: UITableViewCell {

    // MARK: - Constants & Variables
    
    var delegate: InputTableCellProtocol?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentTextView.delegate = self
        
        setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: Functions
    
    func setUp() {
        UIService.textViewUnderline(textView: contentTextView)
    }
    
    
    
}


extension InputTableCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            placeholderLabel.isHidden = false
            return
        }
        placeholderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.cellContentReceived(content: contentTextView.text)
    }
}
