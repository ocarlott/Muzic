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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFiles()
    }
    
    func searchFiles() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: url!, includingPropertiesForKeys: nil, options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles])
            for rl in urls {
                let media = Media()
                if rl.path.contains(".mp3") {
                    media.title = rl.path.replacingOccurrences(of: ".mp3", with: "").replacingOccurrences(of: (url?.path)! + "/", with: "")
                    musics.append(media)
                } else if rl.path.contains(".mp4") {
                    media.title = rl.path.replacingOccurrences(of: ".mp4", with: "").replacingOccurrences(of: (url?.path)! + "/", with: "")
                    videos.append(media)
                }
            }
            for music in musics {
                print(music.title!)
            }
        } catch let error {
            print(error)
        }
        
    }
}
