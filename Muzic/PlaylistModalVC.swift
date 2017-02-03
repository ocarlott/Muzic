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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        view.addSubview(cancelBtn)
        cancelBtn.frame = CGRect(x: 10, y: -40, width: 60, height: 20)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
