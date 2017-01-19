//
//  VideoCell.swift
//  Muzic
//
//  Created by Michael Ngo on 1/18/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let title: UILabel = {
        let lb = UILabel()
        lb.text = "Test"
        lb.numberOfLines = 3
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    let downloadBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "down"), for: .normal)
        return btn
    }()
    
    let channel: UILabel = {
        let lb = UILabel()
        lb.text = "Test channel"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.numberOfLines = 2
        return lb
    }()
    
    func setup(video: Media) {
        addSubview(imageView)
        addSubview(title)
        addSubview(downloadBtn)
        addSubview(channel)
        title.text = video.title
        channel.text = video.channel
        backgroundColor = .white
        if let image = video.imageUrl {
            let url = URL(string: image)!
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error ?? "Error with image url")
                } else {
                    if let imageData = data {
                        let img = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.imageView.image = img
                        }
                    }
                }
            }).resume()
        }
        addConstraintsWithFormatString(format: "H:|[v0(192)]-10-[v1]-5-|", views: imageView, title)
        addConstraintsWithFormatString(format: "H:[v0(30)]|", views: downloadBtn)
        addConstraintsWithFormatString(format: "V:[v0(30)]|", views: downloadBtn)
        addConstraintsWithFormatString(format: "V:|[v0]|", views: imageView)
        addConstraintsWithFormatString(format: "V:|[v0(75)]", views: title)
        addConstraintsWithFormatString(format: "V:[v0(40)]|", views: channel)
        addConstraintsWithFormatString(format: "H:|-202-[v0]-40-|", views: channel)
    }
}
