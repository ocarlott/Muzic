//
//  TabBarViewController.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    var playerController: PlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
        tabBar.barTintColor = UIColor(white: 0, alpha: 0.3)
        tabBar.tintColor = .white
        tabBar.clipsToBounds = true
        toolbarItems = []
        playerController = PlayerController()
        let layout = UICollectionViewFlowLayout()
        let searchController = SearchViewController(collectionViewLayout: layout)
        searchController.playerController = playerController
        searchController.tabBarVC = self
        searchController.tabBarItem.title = "Search"
        searchController.tabBarItem.image = UIImage(named: "search")
        let musicDirVC = DirVC()
        musicDirVC.isVideoType = false
        musicDirVC.playerController = playerController
        musicDirVC.navigationItem.title = "Music"
        let musicController = UINavigationController(rootViewController: musicDirVC)
        musicController.tabBarItem.title = "Music"
        musicController.tabBarItem.image = UIImage(named: "music")
        let videoDirVC = DirVC()
        videoDirVC.isVideoType = true
        videoDirVC.playerController = playerController
        videoDirVC.navigationItem.title = "Video"
        let videoController = UINavigationController(rootViewController: videoDirVC)
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().tintColor = .black
        videoController.tabBarItem.title = "Video"
        videoController.tabBarItem.image = UIImage(named: "video")
        let downloadController = DownloadVC()
        downloadController.playerController = playerController
        let downloadNavigationController = UINavigationController(rootViewController: downloadController)
        downloadNavigationController.tabBarItem.title = "Download"
        downloadNavigationController.tabBarItem.image = UIImage(named: "download")
        searchController.downloadVC = downloadController
        let favoriteController = FavoriteVC()
        favoriteController.playerController = playerController
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteController)
        favoriteNavigationController.tabBarItem.title = "Favorites"
        favoriteNavigationController.tabBarItem.image = UIImage(named: "heart")
        viewControllers = [searchController, musicController, videoController, favoriteNavigationController, downloadNavigationController]
    }
}
