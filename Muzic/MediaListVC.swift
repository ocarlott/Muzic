//
//  MediaListVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/23/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class MediaListVC: CustomTableVC {
    
    let cellId = "cellId"
    
    var workingDir: URL!
    
    var playerController: PlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FileCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 90
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        musics = []
        videos = []
        searchFiles()
    }
    
    func searchFiles() {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: workingDir, includingPropertiesForKeys: nil, options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles])
            for rl in urls {
                let media = Media()
                if rl.path.contains(".mp3") {
                    media.filePath = rl.path
                    media.title = rl.path.replacingOccurrences(of: ".mp3", with: "").replacingOccurrences(of: (workingDir.path) + "/", with: "")
                    media.smallImgPath = PICTURE_DIR_URL.appendingPathComponent(media.title! + ".jpg").path
                    media.largeImgPath = PLAYER_IMAGE_DIR_URL.appendingPathComponent(media.title! + ".jpg").path
                    media.isVideo = false
                    musics.append(media)
                } else if rl.path.contains(".mp4") {
                    media.filePath = rl.path
                    media.title = rl.path.replacingOccurrences(of: ".mp4", with: "").replacingOccurrences(of: (workingDir.path) + "/", with: "")
                    media.smallImgPath = PICTURE_DIR_URL.appendingPathComponent(media.title! + ".jpg").path
                    media.largeImgPath = PLAYER_IMAGE_DIR_URL.appendingPathComponent(media.title! + ".jpg").path
                    media.isVideo = true
                    videos.append(media)
                }
            }
            tableView.reloadData()
        } catch let error {
            print(error)
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count == 0 ? videos.count : musics.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FileCell
        if musics.count == 0 {
            cell.setupViews(media: videos[indexPath.item])
        } else {
            cell.setupViews(media: musics[indexPath.item])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        playerController?.media = (indexPath.section == 0) ? musics[indexPath.item] : videos[indexPath.item]
        present(playerController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: { action, index in
            var tf: UITextField?
            var tmp = Media(), tmp1 = Media()
            if indexPath.section == 0 {
                tmp = self.musics[indexPath.item]
                tmp1.isVideo = false
            } else {
                tmp = self.videos[indexPath.item]
                tmp1.isVideo = true
            }
            let myAlert = UIAlertController(title: "Change Name", message: "Enter new name for this file", preferredStyle: .alert)
            let change = UIAlertAction(title: "Change", style: .default, handler: { action in
                var passed = true
                if tf?.text != "" {
                    for music in self.musics {
                        if tf?.text == music.title { passed = false }
                    }
                    for video in self.videos {
                        if tf?.text == video.title { passed = false }
                    }
                    if passed {
                        tmp1.title = tf?.text
                        tmp1.smallImgPath = tmp.smallImgPath?.replacingOccurrences(of: tmp.title!, with: tmp1.title!)
                        tmp1.largeImgPath = tmp.largeImgPath?.replacingOccurrences(of: tmp.title!, with: tmp1.title!)
                        tmp1.filePath = tmp.filePath?.replacingOccurrences(of: tmp.title!, with: tmp1.title!)
                        if indexPath.section == 0 {
                            self.musics[indexPath.item] = tmp1
                        } else {
                            self.videos[indexPath.item] = tmp1
                        }
                        DispatchQueue.global().async {
                            do {
                                try FileManager.default.moveItem(at: URL(fileURLWithPath: tmp.filePath!), to: URL(fileURLWithPath: tmp1.filePath!))
                                try FileManager.default.moveItem(at: URL(fileURLWithPath: tmp.smallImgPath!), to: URL(fileURLWithPath: tmp1.smallImgPath!))
                                try FileManager.default.moveItem(at: URL(fileURLWithPath: tmp.largeImgPath!), to: URL(fileURLWithPath: tmp1.largeImgPath!))
                                self.tableView.reloadData()
                            } catch let error {
                                print(error)
                            }
                        }
                    }
                }
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            myAlert.addTextField(configurationHandler: { (textField: UITextField) in
                textField.text = tmp.title
                tf = textField
            })
            myAlert.addAction(change)
            myAlert.addAction(cancel)
            self.present(myAlert, animated: true, completion: nil)
        })
        edit.backgroundColor = .green
        let move = UITableViewRowAction(style: .normal, title: "Move", handler: { action, index in
            let modal = PlaylistModalVC()
            modal.workingDir = indexPath.section == 0 ? MUSIC_DIR_URL : VIDEO_DIR_URL
            modal.searchDir()
            modal.indexToRemove = indexPath.item
            modal.workingVC = self
            modal.media = indexPath.section == 0 ? self.musics[indexPath.item] : self.videos[indexPath.item]
            modal.modalPresentationStyle = .overCurrentContext
            self.present(modal, animated: true, completion: nil)
        })
        move.backgroundColor = .blue
        let delete = UITableViewRowAction(style: .destructive, title: "Trash", handler: { action, index in
            var tmp = Media()
            if indexPath.section == 0 {
                tmp = self.musics[indexPath.item]
                self.musics.remove(at: indexPath.item)
            } else {
                tmp = self.videos[indexPath.item]
                self.videos.remove(at: indexPath.item)
            }
            DispatchQueue.global().async {
                do {
                    try FileManager.default.removeItem(at: URL(fileURLWithPath: tmp.filePath!))
                    try FileManager.default.removeItem(at: URL(fileURLWithPath: tmp.smallImgPath!))
                    try FileManager.default.removeItem(at: URL(fileURLWithPath: tmp.largeImgPath!))
                } catch let error {
                    print(error)
                }
            }
            tableView.reloadData()
        })
        delete.backgroundColor = .red
        return [edit, move, delete]
    }


}
