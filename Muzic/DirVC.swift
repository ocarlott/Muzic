//
//  DirVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/23/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

private let cellId = "PlaylistCell"

class DirVC: CustomTableVC {
    
    var dirUrls = [URL]()
    
    var dirs = [String]()
    
    var workingDir: URL?
    
    var playerController: PlayerController?
    
    var mediaListVC: MediaListVC = {
        let vc = MediaListVC()
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        searchDir()
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addDir))
        addBtn.tintColor = .black
        navigationItem.rightBarButtonItem = addBtn
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: cellId)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dirs.count
    }

    func searchDir() {
        dirs = []
        dirUrls = []
        do {
            dirUrls = try FileManager.default.contentsOfDirectory(at: workingDir!, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for dir in dirUrls {
                dirs.append(dir.path.replacingOccurrences(of: (workingDir?.path)! + "/", with: ""))
            }
            tableView.reloadData()
        } catch let error {
            print(error)
        }
    }
    
    func addDir() {
        var inputTF: UITextField?
        let myTextPopup = UIAlertController(title: "Add Playlist", message: "Enter Playlist Name", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if inputTF?.text != "" {
                let newDir = self.workingDir?.appendingPathComponent((inputTF?.text)!, isDirectory: true)
                do {
                    if !FileManager.default.fileExists(atPath: (newDir?.path)!, isDirectory: nil) {
                        try FileManager.default.createDirectory(at: newDir!, withIntermediateDirectories: false, attributes: nil)
                        self.searchDir()
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Playlist name already exists", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(ok)
                        myTextPopup.dismiss(animated: true, completion: nil)
                        self.navigationController?.present(alert, animated: true, completion: nil)
                    }
                } catch let error {
                    print(error)
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
        cell.setupViews(folderName: dirs[indexPath.item])
        cell.tableVC = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mediaListVC.navigationItem.title = dirs[indexPath.item]
        mediaListVC.workingDir = dirUrls[indexPath.item]
        mediaListVC.playerController = playerController
        navigationController?.pushViewController(mediaListVC, animated: true)
    }

}
