//
//  PlaylistModalVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/30/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class PlaylistModalVC: UITableViewController {
    
    let cellId = "cellId"
    
    var dirUrls = [URL]()
    
    var dirs = [String]()
    
    var workingDir: URL!
    
    var workingVC: CustomTableVC!
    
    var media: Media!
    
    var indexToRemove: Int!
    
    var loadedFromDownloadVC = false
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        view.addSubview(cancelBtn)
        cancelBtn.frame = CGRect(x: 10, y: -40, width: 60, height: 20)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dirs.count
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func searchDir() {
        dirs = []
        dirUrls = []
        do {
            dirUrls = try FileManager.default.contentsOfDirectory(at: workingDir, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            for dir in dirUrls {
                dirs.append(dir.path.replacingOccurrences(of: workingDir.path + "/", with: ""))
            }
        } catch let error {
            print(error)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = dirs[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ext = (media?.isVideo)! ? ".mp4" : ".mp3"
        let destinationUrl = dirUrls[indexPath.item].appendingPathComponent((media?.title)! + ext)
        DispatchQueue.global().async {
            do {
                try FileManager.default.moveItem(atPath: (self.media?.filePath)!, toPath: destinationUrl.path)
                DispatchQueue.main.async {
                    if self.media.isVideo! {
                        self.workingVC.videos.remove(at: self.indexToRemove)
                    } else {
                        self.workingVC.musics.remove(at: self.indexToRemove)
                    }
                    self.workingVC.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
        dismiss(animated: true, completion: nil)
    }

}
