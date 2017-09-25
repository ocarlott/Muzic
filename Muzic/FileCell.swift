//
//  FileCell.swift
//  Muzic
//
//  Created by Michael Ngo on 1/20/17.
//

import UIKit
import MuzicFramework
import CoreData

class FileCell: UITableViewCell {
    
    // Variables
    var showIcon = true
    
    let title: UILabel = {
        let lb = UILabel()
        lb.text = " "
        lb.numberOfLines = 3
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    let imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let iconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.alpha = 0.8
        iv.tintColor = .white
        return iv
    }()
    
    // Methods
    
    func setupViews(media: Item) {
        addSubview(title)
        addSubview(imgView)
        imgView.image = UIImage(contentsOfFile: media.imgPath!)
        backgroundColor = .white
        title.text = media.title
        addConstraintsWithFormatString(format: "V:|[v0]|", views: title)
        addConstraintsWithFormatString(format: "V:|[v0]|", views: imgView)
        addConstraintsWithFormatString(format: "H:|[v0(160)]-10-[v1]|", views: imgView, title)
        if showIcon {
            addSubview(iconView)
            iconView.image = media.isVideo ? UIImage(named: "video")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "music")?.withRenderingMode(.alwaysTemplate)
            addConstraintsWithFormatString(format: "H:|-65-[v0(30)]", views: iconView)
            addConstraintsWithFormatString(format: "V:|-30-[v0(30)]", views: iconView)
        }
    }
    
}
