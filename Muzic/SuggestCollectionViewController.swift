//
//  SuggestCollectionViewController.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SuggestCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var keywords: [String]?
    
    var searchVC: SearchViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView?.backgroundColor = UIColor(white: 0, alpha: 0.8)
        self.collectionView!.register(SuggestCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let count = keywords?.count {
            return count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SuggestCell
        // Configure the cell
        if let suggestText = keywords?[indexPath.item] {
            cell.setup(suggestText: suggestText)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 25)
    }
    
    func showSuggestionView(kws: [String]) {
        keywords = kws
        collectionView?.alpha = 1
        collectionView?.reloadData()
        if let window = UIApplication.shared.keyWindow, let cView = collectionView {
            window.addSubview(cView)
            if let count = keywords?.count {
                cView.frame = CGRect(x: 0, y: 70, width: window.frame.width, height: 25 * CGFloat(count + 1))
            }
        }
    }
    
    func hideSuggestionView() {
        collectionView?.alpha = 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let kw = keywords?[indexPath.item]
        searchVC?.inputBox.text = kw
        searchVC?.search()
    }
}
