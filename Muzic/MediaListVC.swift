//
//  MediaListVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/23/17.
//

import UIKit
import AVFoundation
import MuzicFramework
import CoreData

class MediaListVC: CustomTableVC {
    
    // Variables
    
    var playlistItem: Playlist?
    
    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        searchFiles()
        setupPlaylist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if playlistItem?.name == CustomTableVC.updatePlaylist {
            searchFiles()
            setupPlaylist()
            CustomTableVC.updatePlaylist = ""
        }
    }
        
    func searchFiles() {
        medias = playlistItem?.items?.allObjects as! [Item]
        tableView.reloadData()
    }

}

extension MediaListVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FileCell
        cell.showIcon = false
        cell.setupViews(media: medias[indexPath.item])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSelected {
            while true {
                if list?.getCurrentKey().id == medias[indexPath.item].id {
                    break
                }
                list?.next()
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
                        do {
                            try self.context?.save()
                        } catch {
                            print("Failed to save title")
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
        edit.backgroundColor = UIColor(red: 33/255, green: 110/255, blue: 46/255, alpha: 1)
        let delete = UITableViewRowAction(style: .destructive, title: "Trash", handler: { action, index in
            self.medias[indexPath.item].isArchived = false
            self.playlistItem?.removeFromItems(self.medias[indexPath.item])
            self.medias.remove(at: indexPath.item)
            do {
                try self.context?.save()
                DownloadVC.shouldUpdateDownload = true
            } catch {
                print("Cannot delete item from playlist")
            }
            tableView.reloadData()
        })
        delete.backgroundColor = UIColor(red: 139/255, green: 45/255, blue: 45/255, alpha: 1)
        return [edit, delete]
    }
}
