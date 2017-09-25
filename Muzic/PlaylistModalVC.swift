//
//  PlaylistModalVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/30/17.
//

import UIKit
import MuzicFramework
import CoreData

class PlaylistModalVC: UITableViewController {
    
    // Variables
    
    let cellId = "cellId"
    
    var playlists = [String]()
    
    var media: Item?
    
    var downloadVC: DownloadVC?
    
    var indexToBeRemoved: Int?
    
    var context: NSManagedObjectContext?
    
    lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Cancel", for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return btn
    }()

    // Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
        view.addSubview(cancelBtn)
        cancelBtn.frame = CGRect(x: 10, y: -40, width: 60, height: 20)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }

}

extension PlaylistModalVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = playlists[indexPath.item]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", playlists[indexPath.item])
        do {
            let results = try context?.fetch(fetchRequest)
            results?.first?.addToItems(media!)
            media?.isArchived = true
            downloadVC?.medias.remove(at: self.indexToBeRemoved!)
            downloadVC?.archives.append(media!)
            downloadVC?.tableView.reloadData()
            try context?.save()
            CustomTableVC.updatePlaylist = (results?.first?.name)!
        } catch {
            print("Cannot fetch playlist or save item to playlist")
        }
        dismiss(animated: true, completion: nil)
    }
}
