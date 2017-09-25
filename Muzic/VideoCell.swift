//
//  VideoCell.swift
//  Muzic
//
//  Created by Michael Ngo on 1/18/17.
//

import UIKit
import MuzicFramework

class VideoCell: UICollectionViewCell {
    
    // Variables
    
    var video: Media?
    var searchVC: SearchViewController?
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showWebView))
        iv.addGestureRecognizer(gesture)
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
    
    let time: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 9)
        lb.textColor = .white
        lb.layer.cornerRadius = 3
        lb.layer.masksToBounds = true
        lb.textAlignment = .center
        lb.backgroundColor = UIColor(white: 0, alpha: 0.8)
        lb.layer.borderColor = UIColor.white.cgColor
        return lb
    }()
    
    let channel: UILabel = {
        let lb = UILabel()
        lb.text = "Test channel"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.numberOfLines = 2
        return lb
    }()
    
    // Methods
    
    func setup(video: Media) {
        self.video = video
        addSubview(imageView)
        addSubview(title)
        addSubview(downloadBtn)
        addSubview(channel)
        title.text = video.title
        channel.text = video.channel
        backgroundColor = .white
        imageView.addSubview(time)
        time.text = video.duration
        if (searchVC?.ids.contains(video.id!))! {
            downloadBtn.isEnabled = false
        }
        if let image = video.imageUrl {
            ApiService.downloadPreviewImage(urlString: image, videoId: video.id!, completed: { (img, id) in
                DispatchQueue.main.async {
                    if self.video?.id == id {
                        self.imageView.image = img
                    }
                }
            })
        }
        addConstraintsWithFormatString(format: "H:|[v0(192)]-10-[v1]-5-|", views: imageView, title)
        addConstraintsWithFormatString(format: "H:[v0(30)]|", views: downloadBtn)
        addConstraintsWithFormatString(format: "V:[v0(30)]|", views: downloadBtn)
        addConstraintsWithFormatString(format: "V:|[v0]|", views: imageView)
        addConstraintsWithFormatString(format: "V:|[v0(75)]", views: title)
        addConstraintsWithFormatString(format: "V:[v0(40)]|", views: channel)
        addConstraintsWithFormatString(format: "H:|-202-[v0]-40-|", views: channel)
        imageView.addConstraintsWithFormatString(format: "H:[v0(32)]-5-|", views: time)
        imageView.addConstraintsWithFormatString(format: "V:[v0(20)]-5-|", views: time)
    }
    
    @objc func showWebView() {
        searchVC?.showWebView(id: (video?.id)!)
    }
    
    @objc func askToDownload() {
        if let v = self.video {
            downloadBtn.isEnabled = false
            let myActionSheet = UIAlertController(title: "Download File Type", message: "Video or Audio only?", preferredStyle: .actionSheet)
            let videoAction = UIAlertAction(title: "Video", style: .default, handler: { (action) in
                v.isVideo = true
                ApiService.downloadMedia(media: v, completed: {
                    DispatchQueue.main.async {
                        self.searchVC?.downloadVC?.updatePlaylist()
                    }
                    self.downloadNotification(title: v.title! + ".mp4")
                    self.downloadBtn.isEnabled = true
                })
            })
            let audioAction = UIAlertAction(title: "Audio Only", style: .default, handler: { (action) in
                v.isVideo = false
                ApiService.downloadMedia(media: v, completed: {
                    DispatchQueue.main.async {
                        self.searchVC?.downloadVC?.updatePlaylist()
                    }
                    self.downloadNotification(title: v.title! + ".mp3")
                    self.downloadBtn.isEnabled = true
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
        searchVC?.tabBarVC?.present(myAlertBox, animated: true, completion: nil)
    }
}
