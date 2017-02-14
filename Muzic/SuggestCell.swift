//
//  SuggestCell.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class SuggestCell: UICollectionViewCell {
    
    var text: UILabel = {
        let text = UILabel()
        text.textColor = .white
        return text
    }()
    
    func setup(suggestText: String) {
        text.text = suggestText
        addSubview(text)
        addConstraintsWithFormatString(format: "H:|-10-[v0]|", views: text)
        addConstraintsWithFormatString(format: "V:|[v0]|", views: text)
    }
}
