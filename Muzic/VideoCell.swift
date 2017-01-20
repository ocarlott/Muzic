//
//  VideoCell.swift
//  Muzic
//
//  Created by Michael Ngo on 1/18/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    var video: Media?
    var searchVC: SearchViewController?
    
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
    
    lazy var downloadBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "down"), for: .normal)
        btn.addTarget(self, action: #selector(askToDownload), for: .touchUpInside)
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
        self.video = video
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
    
    func askToDownload() {
        if let v = self.video {
            let myActionSheet = UIAlertController(title: "Download File Type", message: "Video or Audio only?", preferredStyle: .actionSheet)
            let videoAction = UIAlertAction(title: "Video", style: .default, handler: { (action) in
                ApiService.downloadMedia(media: v, video: true, completed: {
                    self.downloadNotification(title: v.title! + ".mp4")
                })
            })
            let audioAction = UIAlertAction(title: "Audio Only", style: .default, handler: { (action) in
                ApiService.downloadMedia(media: v, video: false, completed: {
                    self.downloadNotification(title: v.title! + ".mp3")
                })
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            myActionSheet.addAction(videoAction)
            myActionSheet.addAction(audioAction)
            myActionSheet.addAction(cancelAction)
            searchVC?.present(myActionSheet, animated: true, completion: nil)
        }
    }
    
    func downloadNotification(title: String) {
        let myAlertBox = UIAlertController(title: "Download Completed", message: title + " has been downloaded.", preferredStyle: .alert)
        myAlertBox.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        searchVC?.present(myAlertBox, animated: true, completion: nil)
    }
}