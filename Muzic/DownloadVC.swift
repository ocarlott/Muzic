//
//  DownloadVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/20/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class DownloadVC: GenericSearchVC {
    
    var musics = [Media]()
    
    var videos = [Media]()
    
    var playerController: PlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFiles()
        addCollectionView()
    }
    
    lazy var fileVC: FileExploreVC = {
        let layout = UICollectionViewFlowLayout()
        let vc = FileExploreVC(collectionViewLayout: layout)
        vc.downloadVC = self
        return vc
    }()
    
    func searchFiles() {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: DOCUMENT_DIR_URL, includingPropertiesForKeys: nil, options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles])
            for rl in urls {
                let media = Media()
                if rl.path.contains(".mp3") {
                    media.path = rl.path
                    media.title = rl.path.replacingOccurrences(of: ".mp3", with: "").replacingOccurrences(of: (DOCUMENT_DIR_URL.path) + "/", with: "")
                    media.isVideo = false
                    musics.append(media)
                } else if rl.path.contains(".mp4") {
                    media.path = rl.path
                    media.title = rl.path.replacingOccurrences(of: ".mp4", with: "").replacingOccurrences(of: (DOCUMENT_DIR_URL.path) + "/", with: "")
                    media.isVideo = true
                    videos.append(media)
                }
            }
        } catch let error {
            print(error)
        }
        fileVC.musics = musics
        fileVC.videos = videos
    }
    
    func addCollectionView() {
        view.addSubview(fileVC.collectionView!)
        view.addConstraintsWithFormatString(format: "V:|-70-[v0]|", views: fileVC.collectionView!)
        view.addConstraintsWithFormatString(format: "H:|[v0]|", views: fileVC.collectionView!)
    }
    
    func clearCache() {
        musics = []
        videos = []
    }
}
