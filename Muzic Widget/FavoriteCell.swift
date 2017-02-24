//
//  FavoriteCell.swift
//  Muzic
//
//  Created by Michael Ngo on 2/19/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import MuzicFramework
import CoreData

class FavoriteCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let title: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 9)
        lb.numberOfLines = 2
        lb.text = "Test"
        return lb
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupViews(media: Item) {
        addSubview(imageView)
        addSubview(title)
        title.text = media.title
        imageView.image = UIImage(contentsOfFile: media.imgPath!)
        addConstraintsWithFormatString(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormatString(format: "H:|-5-[v0]-5-|", views: title)
        addConstraintsWithFormatString(format: "V:|[v0(56.25)]-5-[v1]-5-|", views: imageView, title)
    }

}
