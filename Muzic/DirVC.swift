//
//  DirVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/23/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

private let cellId = "PlaylistCell"

class DirVC: UITableViewController {
    
    var dirUrls = [URL]()
    
    var dirs = [String]()
    
    var workingDir: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem
        searchDir()
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addDir))
        addBtn.tintColor = .black
        navigationItem.rightBarButtonItem = addBtn
        tableView.register(PlaylistCell.self, forCellReuseIdentifier: cellId)
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

}
