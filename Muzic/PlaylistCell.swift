//
//  PlaylistCell.swift
//  Muzic
//
//  Created by Michael Ngo on 1/23/17.
//

import UIKit

class PlaylistCell: UITableViewCell {

    // Variables
    var tableVC: DirVC?
    
    var playlistItem: Playlist?
    
    lazy var editBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "edit") , for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(editPlaylist), for: .touchUpInside)
        return btn
    }()
    
    let playlist: UILabel = {
        let lb = UILabel()
        lb.text = "Test"
        return lb
    }()
    
    
    // Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupViews() {
        addSubview(playlist)
        addSubview(editBtn)
        playlist.text = playlistItem?.name
        addConstraintsWithFormatString(format: "V:|[v0]|", views: playlist)
        addConstraintsWithFormatString(format: "V:|-10-[v0]-10-|", views: editBtn)
        addConstraintsWithFormatString(format: "H:|-30-[v0]-20-[v1(20)]-20-|", views: playlist, editBtn)
    }
    
    @objc func editPlaylist() {
        var nameTF: UITextField?
        let myEditPopup = UIAlertController(title: "Change Playlist Name", message: "Enter new name for this playlist", preferredStyle: .alert)
        let changeAction = UIAlertAction(title: "Change", style: .default, handler: { (action) in
            if nameTF?.text != "" {
                var passed = true
                for pl in (self.tableVC?.playlistItems)! {
                    if pl.name == nameTF?.text {
                        let alert = UIAlertController(title: "Error", message: "Playlist name exists!", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                        passed = false
                        alert.addAction(ok)
                        myEditPopup.dismiss(animated: true, completion: nil)
                        self.tableVC?.navigationController?.present(alert, animated: true, completion: nil)
                        break
                    }
                }
                if passed {
                    self.playlistItem?.name = nameTF?.text
                    do {
                        try self.tableVC?.context?.save()
                        self.tableVC?.tableView.reloadData()
                    } catch {
                        print("Cannot save playlist")
                    }
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "Playlist name cannot be left blank!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                myEditPopup.dismiss(animated: true, completion: nil)
                self.tableVC?.navigationController?.present(alert, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        myEditPopup.addAction(changeAction)
        myEditPopup.addAction(cancelAction)
        myEditPopup.addTextField(configurationHandler: { (tf: UITextField) in
            nameTF = tf
            tf.text = self.playlist.text
        })
        tableVC?.navigationController?.present(myEditPopup, animated: true, completion: nil)
    }

}
