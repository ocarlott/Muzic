//
//  SearchViewController.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import MuzicFramework

class SearchViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var keywords: [String]?
    
    var videos = [Media]()
    
    var tabBarVC: UITabBarController?
    
    let suggestCellId = "suggestCell"
    
    let videoCellId = "videoId"
    
    var isDoneTyping = false
    
    let inputBox: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Search"
        tf.textAlignment = .center
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(SuggestCell.self, forCellWithReuseIdentifier: suggestCellId)
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: videoCellId)
        setupViews()
    }
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    let bgImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bg"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var downloadVC: DownloadVC?
    
    var playerController: PlayerController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupViews() {
        navigationItem.title = "Search"
        view.addSubview(bgImage)
        view.addSubview(background)
        view.addSubview(inputBox)
        view.sendSubview(toBack: background)
        view.sendSubview(toBack: bgImage)
        collectionView?.backgroundColor = UIColor(white: 0, alpha: 0)
        collectionView?.clipsToBounds = true
        inputBox.addTarget(nil, action: #selector(search), for: .editingDidEndOnExit)
        inputBox.addTarget(nil, action: #selector(suggest), for: .editingChanged)
        view.addConstraintsWithFormatString(format: "V:|-20-[v0]|", views: bgImage)
        view.addConstraintsWithFormatString(format: "V:|-20-[v0]|", views: background)
        view.addConstraintsWithFormatString(format: "H:|-20-[v0]-20-|", views: bgImage)
        view.addConstraintsWithFormatString(format: "H:|[v0]|", views: background)
        view.addConstraintsWithFormatString(format: "V:|-30-[v0(30)]", views: inputBox)
        view.addConstraintsWithFormatString(format: "H:|-5-[v0]-5-|", views: inputBox)
        collectionView?.frame = CGRect(x: 10, y: 70, width: view.frame.width - 20, height: view.frame.height)
    }
    
    func search() {
        inputBox.resignFirstResponder()
        if let text = inputBox.text, text != "" {
            ApiService.search(keyword: text, completed: { (videos) in
                self.videos = videos
                self.isDoneTyping = true
                self.collectionView?.isScrollEnabled = true
                self.collectionView?.reloadData()
            })
        } else {
            keywords = []
            collectionView?.reloadData()
        }
    }
    
    func suggest() {
        if let text = inputBox.text, text != "" {
            ApiService.getSuggestions(keyword: text, completed: { (suggestions) in
                self.keywords = suggestions
                self.isDoneTyping = false
                self.collectionView?.isScrollEnabled = false
                self.collectionView?.reloadData()
            })
        } else {
            keywords = []
            collectionView?.reloadData()
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isDoneTyping {
            return videos.count
        }
        if let count = keywords?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isDoneTyping {
            return CGSize(width: collectionView.frame.width, height: 108)
        }
        return CGSize(width: collectionView.frame.width, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if isDoneTyping {
            return 20
        }
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isDoneTyping {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell
            cell.setup(video: videos[indexPath.item])
            cell.searchVC = self
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: suggestCellId, for: indexPath) as! SuggestCell
        if let suggestText = keywords?[indexPath.item] {
            cell.setup(suggestText: suggestText)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isDoneTyping {
            let kw = keywords?[indexPath.item]
            inputBox.text = kw
            search()
        }
    }

}
