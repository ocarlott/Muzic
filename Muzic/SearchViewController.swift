//
//  SearchViewController.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class SearchViewController: GenericSearchVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    var downloadVC: DownloadVC?
    
    var playerController: PlayerController?
    
    lazy var suggestBox: SuggestCollectionViewController = {
        let layout = UICollectionViewFlowLayout()
        var sb = SuggestCollectionViewController(collectionViewLayout: layout)
        sb.searchVC = self
        return sb
    }()
    
    lazy var resultBox: SearchResultVC = {
        let layout = UICollectionViewFlowLayout()
        var rb = SearchResultVC(collectionViewLayout: layout)
        rb.searchVC = self
        return rb
    }()
    
    override func setupViews() {
        view.backgroundColor = .white
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .white
        navigationItem.title = "Search"
        view.addSubview(bgImage)
        view.addSubview(background)
        view.addSubview(inputBox)
        inputBox.addTarget(nil, action: #selector(SearchViewController.search), for: .editingDidEndOnExit)
        inputBox.addTarget(nil, action: #selector(SearchViewController.suggest), for: .editingChanged)
        view.addConstraintsWithFormatString(format: "V:|-20-[v0]|", views: bgImage)
        view.addConstraintsWithFormatString(format: "V:|-20-[v0]|", views: background)
        view.addConstraintsWithFormatString(format: "H:|[v0]|", views: bgImage)
        view.addConstraintsWithFormatString(format: "H:|[v0]|", views: background)
        view.addConstraintsWithFormatString(format: "V:|-30-[v0(30)]", views: inputBox)
        view.addConstraintsWithFormatString(format: "H:|-5-[v0]-5-|", views: inputBox)
    }
    
    func search() {
        inputBox.resignFirstResponder()
        suggestBox.hideSuggestionView()
//        suggestBox.dismiss(animated: false, completion: nil)
        if let text = inputBox.text, text != "" {
            ApiService.search(keyword: text, completed: { (videos) in
                self.resultBox.showResultView(vds: videos)
            })
        }
    }
    
    func suggest() {
        resultBox.hideResultView()
//        resultBox.dismiss(animated: false, completion: nil)
        if let text = inputBox.text, text != "" {
            ApiService.getSuggestions(keyword: text, completed: { (suggestions) in
                self.suggestBox.showSuggestionView(kws: suggestions)
            })
        }
    }

}
