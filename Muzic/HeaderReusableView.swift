//
//  HeaderReusableView.swift
//  Muzic
//
//  Created by Michael Ngo on 1/22/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class HeaderReusableView: UICollectionReusableView {
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = "Test"
        lb.textAlignment = .center
        lb.textColor = .white
        return lb
    }()
    
    func setupViews() {
        addSubview(label)
        addConstraintsWithFormatString(format: "H:|[v0]|", views: label)
        addConstraintsWithFormatString(format: "V:|[v0]|", views: label)
    }
}
