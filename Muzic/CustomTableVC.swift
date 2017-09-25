//
//  CustomTableVC.swift
//  Muzic
//
//  Created by Michael Ngo on 2/3/17.
//

import UIKit
import MuzicFramework
import CoreData
import AVFoundation

class CustomTableVC: UITableViewController {
    
    // Variables
    
    static var updatePlaylist = ""
    
    var medias = [Item]()
        
    var playlist = [Item]()
    
    var list: List<Item>?
    
    var isSelected = false
    
    var isReadyToPlay = false
    
    var context: NSManagedObjectContext?
    
    var entity: NSEntityDescription?
    
    let reuseIdentifier = "CellId"
    
    var playerController: PlayerController!
    
    // Methods

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
            self.list = List<Item>()
            for media in self.playlist {
                self.list?.add(key: media)
            }
            self.isReadyToPlay = true
        }
    }

}
