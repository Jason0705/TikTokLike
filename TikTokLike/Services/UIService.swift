//
//  UIService.swift
//  TikTokLike
//
//  Created by Jason Li on 2019-04-19.
//  Copyright © 2019 Jason Li. All rights reserved.
//

import UIKit

class UIService {
    
    static func textFieldUnderline(textField: UITextField) {
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 0.6)
        bottomLayer.backgroundColor = UIColor.gray.cgColor
        textField.layer.addSublayer(bottomLayer)
    }
    
    
    static func threeCellPerRowStyle(view: UIView, lineSpacing: CGFloat, itemSpacing: CGFloat, inset: CGFloat, heightMultiplier: CGFloat) -> UICollectionViewFlowLayout {
        let cellWidth = (view.frame.size.width - (inset * 2) - (itemSpacing * 2)) / 3
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * heightMultiplier)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = itemSpacing
        
        return layout
    }
}
