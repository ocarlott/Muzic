//
//  FavoriteVC.swift
//  Muzic
//
//  Created by Michael Ngo on 2/20/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import MuzicFramework
import CoreData

class FavoriteVC: DownloadVC {
    
    static var shouldUpdateFavorite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favorites"
        setupTable()
        updatePlaylist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if FavoriteVC.shouldUpdateFavorite {
            updatePlaylist()
        }
    }
    
    override func searchFiles() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorited == %@", NSNumber(booleanLiteral: true))
        do {
            if let results = try context?.fetch(fetchRequest) {
                medias = results
            }
        } catch {
            print("Cannot fetch favorite items")
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Trash", handler: { action, index in
            DispatchQueue.global().async {
                do {
                    self.medias[indexPath.item].isFavorited = false
                    try self.context?.save()
                    self.medias.remove(at: indexPath.item)
                } catch let error {
                    print(error)
                }
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
            }
        })
        delete.backgroundColor = .red
        return [delete]
    }

}
