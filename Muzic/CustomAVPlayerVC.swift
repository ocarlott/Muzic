//
//  CustomAVPlayerVC.swift
//  Muzic
//
//  Created by Michael Ngo on 2/2/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import AVKit

class CustomAVPlayerVC: AVPlayerViewController {
        
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause()
    }

}
