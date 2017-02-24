//
//  DirVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/23/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import CoreData

private let cellId = "PlaylistCell"

class DirVC: CustomTableVC {
    
    var playlistItems = [Playlist]()
    
    var isVideoType: Bool?
        
    var mediaListVC: MediaListVC = {
        let vc = MediaListVC()
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchPlaylists()
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPlaylist))
        addBtn.tintColor = .black
        navigationItem.rightBarButtonItem = addBtn
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: cellId)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistItems.count
    }

    func searchPlaylists() {
        let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isVideoType == %@", NSNumber(booleanLiteral: isVideoType!))
        do {
            if let results = try context?.fetch(fetchRequest) {
                playlistItems = results
            }
            tableView.reloadData()
        } catch {
            print("Failed to fetch playlists")
        }
    }
    
    func addPlaylist() {
        var inputTF: UITextField?
        let myTextPopup = UIAlertController(title: "Add Playlist", message: "Enter Playlist Name", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if inputTF?.text != "" {
                var passed = true
                for pl in self.playlistItems {
                    if pl.name == inputTF?.text {
                        let alert = UIAlertController(title: "Error", message: "Playlist name exists!", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                        passed = false
                        alert.addAction(ok)
                        myTextPopup.dismiss(animated: true, completion: nil)
                        self.navigationController?.present(alert, animated: true, completion: nil)
                        break
                    }
                }
                if passed {
                    let newPlaylist = Playlist(context: self.context!)
                    newPlaylist.name = inputTF?.text
                    newPlaylist.isVideoType = self.isVideoType!
                    do {
                        try self.context?.save()
                        self.playlistItems.append(newPlaylist)
                        self.tableView.reloadData()
                    } catch {
                        print("Cannot save new playlist")
                    }
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Playlist name cannot be left blank!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                myTextPopup.dismiss(animated: true, completion: nil)
                self.navigationController?.present(alert, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        myTextPopup.addAction(addAction)
        myTextPopup.addAction(cancelAction)
        myTextPopup.addTextField(configurationHandler: {(textField: UITextField) in
            textField.placeholder = "Playlist Name"
            inputTF = textField
        })
        navigationController?.present(myTextPopup, animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PlaylistCell
        cell.playlistItem = playlistItems[indexPath.item]
        cell.setupViews()
        cell.tableVC = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mediaListVC.navigationItem.title = playlistItems[indexPath.item].name
        mediaListVC.playlistItem = playlistItems[indexPath.item]
        mediaListVC.searchFiles()
        mediaListVC.playerController = playerController
        navigationController?.pushViewController(mediaListVC, animated: true)
    }

}
