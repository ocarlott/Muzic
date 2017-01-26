//
//  TabBarViewController.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
        tabBar.barTintColor = UIColor(white: 0, alpha: 0.3)
        tabBar.tintColor = .white
        tabBar.clipsToBounds = true
        toolbarItems = []
        let searchController = SearchViewController()
        searchController.tabBarItem.title = "Search"
        searchController.tabBarItem.image = UIImage(named: "search")
        let musicDirVC = MusicVC()
        musicDirVC.navigationItem.title = "Music"
        let musicController = UINavigationController(rootViewController: musicDirVC)
        musicController.tabBarItem.title = "Music"
        musicController.tabBarItem.image = UIImage(named: "music")
        let videoDirVC = VideoVC()
        videoDirVC.navigationItem.title = "Video"
        let videoController = UINavigationController(rootViewController: videoDirVC)
        UINavigationBar.appearance().backgroundColor = .black
        UINavigationBar.appearance().tintColor = .black
        videoController.tabBarItem.title = "Video"
        videoController.tabBarItem.image = UIImage(named: "video")
        let downloadController = DownloadVC()
        downloadController.tabBarItem.title = "Download"
        downloadController.tabBarItem.image = UIImage(named: "download")
        searchController.downloadVC = downloadController
        viewControllers = [searchController, musicController, videoController, downloadController]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
