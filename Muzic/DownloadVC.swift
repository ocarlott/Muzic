//
//  DownloadVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/20/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import AVFoundation
import MuzicFramework
import CoreData

class DownloadVC: CustomTableVC {
    
    static var shouldUpdateDownload = false
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = "Downloads"
        lb.textColor = .white
        return lb
    }()
    
    var archives = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Downloads"
        setupTable()
        updatePlaylist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if DownloadVC.shouldUpdateDownload {
            updatePlaylist()
            DownloadVC.shouldUpdateDownload = false
        }
    }
    
    func updatePlaylist() {
        medias = []
        searchFiles()
        setupPlaylist()
        tableView.reloadData()
    }
    
    func searchFiles() {
        do {
            let fetchRequest: NSFetchRequest<Download> = Download.fetchRequest()
            let download = try context?.fetch(fetchRequest)
            if let temp = download?.first?.items?.allObjects as! [Item]? {
                for media in temp {
                    if media.isArchived {
                        archives.append(media)
                    } else {
                        medias.append(media)
                    }
                }
            }
            tableView.reloadData()
        } catch let err {
            print(err)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FileCell
        cell.setupViews(media: medias[indexPath.item])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isReadyToPlay {
            while true {
                if list.getCurrentKey().media.title == playlist[indexPath.item].title { break }
                list.next()
            }
            playerController.playlist = list
            playerController.context = context
            present(playerController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: { action, index in
            var tf: UITextField?
            let myAlert = UIAlertController(title: "Change Name", message: "Enter new name for this file", preferredStyle: .alert)
            let change = UIAlertAction(title: "Change", style: .default, handler: { action in
                var passed = true
                if tf?.text != "" {
                    for media in self.medias {
                        if media.title == tf?.text {
                            passed = false
                            break
                        }
                    }
                    if passed {
                        self.medias[indexPath.item].title = tf?.text
                        if self.medias[indexPath.item].isFavorited {
                            FavoriteVC.shouldUpdateFavorite = true
                        }
                        DownloadVC.shouldUpdateDownload = true
                        do {
                            try self.context?.save()
                        } catch {
                            print("Failed to save")
                        }
                    }
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            myAlert.addTextField(configurationHandler: { (textField: UITextField) in
                textField.text = self.medias[indexPath.item].title
                tf = textField
            })
            myAlert.addAction(change)
            myAlert.addAction(cancel)
            self.present(myAlert, animated: true, completion: nil)
        })
        edit.backgroundColor = .green
        let move = UITableViewRowAction(style: .normal, title: "Move", handler: { action, index in
            let modal = PlaylistModalVC()
            modal.media = self.medias[indexPath.item]
            let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isVideoType == %@", NSNumber(booleanLiteral: self.medias[indexPath.item].isVideo))
            modal.context = self.context
            modal.downloadVC = self
            modal.indexToBeRemoved = indexPath.item
            do {
                let results = try self.context?.fetch(fetchRequest)
                var playlists = [String]()
                for result in results! {
                    playlists.append(result.name!)
                }
                modal.playlists = playlists
            } catch {
                print("Cannot fetch playlists")
            }
            modal.modalPresentationStyle = .overCurrentContext
            self.present(modal, animated: true, completion: nil)
        })
        move.backgroundColor = .blue
        let delete = UITableViewRowAction(style: .destructive, title: "Trash", handler: { action, index in
            DispatchQueue.global().async {
                do {
                    let fetchRequest1: NSFetchRequest<Download> = Download.fetchRequest()
                    let fetchRequest2: NSFetchRequest<Playlist> = Playlist.fetchRequest()
                    if let results = try self.context?.fetch(fetchRequest1) {
                        results.first?.removeFromItems(self.medias[indexPath.item])
                    }
                    if let results = try self.context?.fetch(fetchRequest2) {
                        for pl in results {
                            pl.removeFromItems(self.medias[indexPath.item])
                        }
                    }
                    if self.medias[indexPath.item].isFavorited {
                        FavoriteVC.shouldUpdateFavorite = true
                    }
                    self.context?.delete(self.medias[indexPath.item])
                    try FileManager.default.removeItem(at: URL(fileURLWithPath: self.medias[indexPath.item].filePath!))
                    try FileManager.default.removeItem(at: URL(fileURLWithPath: self.medias[indexPath.item].imgPath!))
                    self.medias.remove(at: indexPath.item)
                    try self.context?.save()
                } catch let error {
                    print(error)
                }
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            }
        })
        delete.backgroundColor = .red
        return [edit, move, delete]
    }

}
