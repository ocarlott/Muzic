//
//  CustomAVPlayerVC.swift
//  Muzic
//
//  Created by Michael Ngo on 2/2/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import AVKit

class CustomAVPlayerVC: AVPlayerViewController {
    
//    var playerController: PlayerController?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
