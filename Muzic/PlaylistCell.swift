//
//  PlaylistCell.swift
//  Muzic
//
//  Created by Michael Ngo on 1/23/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class PlaylistCell: UITableViewCell {

    var tableVC: DirVC?
    
    lazy var editBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "edit") , for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(editDir), for: .touchUpInside)
        return btn
    }()
    
    let playlist: UILabel = {
        let lb = UILabel()
        lb.text = "Test"
        return lb
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViews(folderName: String) {
        addSubview(playlist)
        addSubview(editBtn)
        playlist.text = folderName
        addConstraintsWithFormatString(format: "V:|[v0]|", views: playlist)
        addConstraintsWithFormatString(format: "V:|-10-[v0]-10-|", views: editBtn)
        addConstraintsWithFormatString(format: "H:|-30-[v0]-20-[v1(20)]-20-|", views: playlist, editBtn)
    }
    
    func editDir() {
        var nameTF: UITextField?
        let oldDir = MUSIC_DIR_URL?.appendingPathComponent(playlist.text!, isDirectory: true)
        let myEditPopup = UIAlertController(title: "Change Playlist Name", message: "Enter new name for this playlist", preferredStyle: .alert)
        let changeAction = UIAlertAction(title: "Change", style: .default, handler: { (action) in
            if nameTF?.text != "" {
                let newDir = MUSIC_DIR_URL?.appendingPathComponent((nameTF?.text)!, isDirectory: true)
                do {
                    try FileManager.default.moveItem(at: oldDir!, to: newDir!)
                    self.tableVC?.searchDir()
                } catch let error {
                    print(error)
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
