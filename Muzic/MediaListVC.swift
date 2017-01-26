//
//  MediaListVC.swift
//  Muzic
//
//  Created by Michael Ngo on 1/23/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit

class MediaListVC: GenericSearchVC {
    
    var workingDir: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = workingDir
    }
}
