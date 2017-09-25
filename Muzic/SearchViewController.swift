//
//  SearchViewController.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//

import UIKit
import MuzicFramework
import CoreData

class SearchViewController: UICollectionViewController, UIWebViewDelegate {
    
    var keywords: [String]?
    
    var videos = [Media]()
    
    var ids = [String]()
    
    var context: NSManagedObjectContext?
    
    var tabBarVC: UITabBarController?
    
    let suggestCellId = "suggestCell"
    
    let videoCellId = "videoId"
    
    var isDoneTyping = false
    
    var isReadyToSearch = false
    
    lazy var playbackBg: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.9)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideWebView))
        view.addGestureRecognizer(gesture)
        view.alpha = 0
        return view
    }()
    
    let webView: UIWebView = {
        let web = UIWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        web.backgroundColor = .white
        return web
    }()
    
    let inputBox: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Search"
        tf.textAlignment = .center
        return tf
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(SuggestCell.self, forCellWithReuseIdentifier: suggestCellId)
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: videoCellId)
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getItems()
    }

}

extension SearchViewController {
    
    func getItems() {
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate? {
            self.context = appDelegate.context
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            do {
                if let results = try self.context?.fetch(fetchRequest) {
                    for result in results {
                        self.ids.append(result.id!)
                    }
                    self.isReadyToSearch = true
                }
            } catch {
                print("Cannot fetch items")
            }
        }
    }
    
    func setupViews() {
        navigationItem.title = "Search"
        view.addSubview(bgImage)
        view.addSubview(background)
        view.addSubview(inputBox)
        view.sendSubview(toBack: background)
        view.sendSubview(toBack: bgImage)
        playbackBg.addSubview(webView)
        view.addSubview(playbackBg)
        playbackBg.frame = view.frame
        webView.centerXAnchor.constraint(equalTo: playbackBg.centerXAnchor).isActive = true
        webView.centerYAnchor.constraint(equalTo: playbackBg.centerYAnchor).isActive = true
        webView.widthAnchor.constraint(equalToConstant: playbackBg.frame.width).isActive = true
        webView.heightAnchor.constraint(equalToConstant: playbackBg.frame.width * 9 / 16).isActive = true
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
    
    @objc func search() {
        if isReadyToSearch {
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
    }
    
    @objc func suggest() {
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
    
    @objc func hideWebView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.playbackBg.alpha = 0
        }, completion: nil)
    }
    
    func showWebView(id: String) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            let str = "https://www.youtube.com/watch?v=\(id)&feature=player_embedded"
            self.webView.loadRequest(URLRequest(url: URL(string: str)!))
            self.playbackBg.alpha = 1
        }, completion: nil)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        webView.stringByEvaluatingJavaScript(from: "document.body.style.margin='0';document.body.style.padding='0'")
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isDoneTyping {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellId, for: indexPath) as! VideoCell
            cell.searchVC = self
            cell.setup(video: videos[indexPath.item])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: suggestCellId, for: indexPath) as! SuggestCell
        if let suggestText = keywords?[indexPath.item] {
            cell.setup(suggestText: suggestText)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isDoneTyping {
            let kw = keywords?[indexPath.item]
            inputBox.text = kw
            search()
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 130, right: 0)
    }
}
