//
//  CustomTableVC.swift
//  Muzic
//
//  Created by Michael Ngo on 2/3/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import MuzicFramework

class CustomTableVC: UITableViewController {
    
    var musics = [Media]()
    
    var videos = [Media]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func searchDir() {
        
    }
}
