//
//  FavoriteVC.swift
//  Muzic
//
//  Created by Michael Ngo on 2/20/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import MuzicFramework

class FavoriteVC: DownloadVC {

    let defaults = UserDefaults(suiteName: "group.appdev")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorites"
        if let data = defaults?.data(forKey: "favorite") {
            let arr = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Media]
            for media in arr {
                if media.isVideo! {
                    videos.append(media)
                } else {
                    musics.append(media)
                }
            }
        }
        setupTableAndPlaylist()
    }

}
