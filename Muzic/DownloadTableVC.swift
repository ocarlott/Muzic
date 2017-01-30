//
//  DownloadTableVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/30/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DownloadTableVC: UITableViewController {
    
    var musics = [Media]()
    
    var videos = [Media]()
    
    var downloadVC: DownloadVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(FileCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 90
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return musics.count
        } else {
            return videos.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! FileCell
        if indexPath.section == 0 {
            cell.setupViews(media: musics[indexPath.item])
        } else {
            cell.setupViews(media: videos[indexPath.item])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        downloadVC?.playerController?.media = (indexPath.section == 0) ? musics[indexPath.item] : videos[indexPath.item]
        downloadVC?.present((downloadVC?.playerController)!, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Musics"
        }
        return "Videos"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
            self.downloadVC?.present(myAlert, animated: true, completion: nil)
        })
        edit.backgroundColor = .green
        let move = UITableViewRowAction(style: .normal, title: "Move", handler: { action, index in
            print("ab")
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
