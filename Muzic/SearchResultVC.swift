//
//  SearchResultVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/18/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SearchResultVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var videos = [Media]()
    
    var searchVC: SearchViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(VideoCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VideoCell
        cell.setup(video: videos[indexPath.item])
        cell.searchVC = searchVC
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 108)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func showResultView(vds: [Media]) {
        collectionView?.alpha = 1
        videos = vds
        collectionView?.reloadData()
        searchVC?.view.addSubview(collectionView!)
        searchVC?.view.addConstraintsWithFormatString(format: "V:|-70-[v0]|", views: collectionView!)
        searchVC?.view.addConstraintsWithFormatString(format: "H:|[v0]|", views: collectionView!)
    }

    func hideResultView() {
//        collectionView?.alpha = 0
        collectionView?.removeFromSuperview()
    }

}
