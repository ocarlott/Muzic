//
//  CustomTableVC.swift
//  Muzic
//
//  Created by Michael Ngo on 2/3/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import MuzicFramework
import CoreData
import AVFoundation

class CustomTableVC: UITableViewController {
    
    static var updatePlaylist = ""
    
    var medias = [Item]()
        
    var playlist = [Item]()
    
    var list = List<MediaInfo<Item>>()
    
    var isSelected = false
    
    var isReadyToPlay = false
    
    var context: NSManagedObjectContext?
    
    var entity: NSEntityDescription?
    
    let reuseIdentifier = "CellId"
    
    var playerController: PlayerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        if let appDelegate = UIApplication.shared.delegate as! AppDelegate? {
            context = appDelegate.context
            entity = NSEntityDescription.entity(forEntityName: "Item", in: context!)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func setupTable() {
        self.tableView.register(FileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 90
        tableView.clipsToBounds = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    func setupPlaylist() {
        DispatchQueue.global().async {
            self.playlist = self.medias
            self.playlist.shuffle()
            for media in self.playlist {
                if let filePath = media.filePath {
                    let url = URL(fileURLWithPath: filePath)
                    let item = AVPlayerItem(url: url)
                    let listItem = MediaInfo(media: media, item: item)
                    self.list.add(key: listItem)
                }
            }
            self.isReadyToPlay = true
        }
    }

}
