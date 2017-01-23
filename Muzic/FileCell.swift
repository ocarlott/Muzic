//
//  FileCell.swift
//  Muzic
//
//  Created by Michael Ngo on 1/20/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class FileCell: UICollectionViewCell {
    
    let title: UILabel = {
        let lb = UILabel()
        lb.text = "Test"
        lb.numberOfLines = 3
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    func setupViews(media: Media) {
        addSubview(title)
        addSubview(imageView)
        imageView.image = UIImage(contentsOfFile: URL(fileURLWithPath: (PICTURE_DIR_URL?.path)!).appendingPathComponent(media.title! + ".jpg").path)
        backgroundColor = .white
        title.text = media.title
        addConstraintsWithFormatString(format: "V:|[v0]|", views: title)
        addConstraintsWithFormatString(format: "V:|[v0]|", views: imageView)
        addConstraintsWithFormatString(format: "H:|[v0(160)]-10-[v1]|", views: imageView, title)
    }
    
}
