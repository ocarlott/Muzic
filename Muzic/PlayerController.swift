//
//  PlayerController.swift
//  Muzic
//
//  Created by Michael Ngo on 1/25/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerController: UIViewController {

    let playImage = UIImage(named: "play")
    
    let pauseImage = UIImage(named: "pause")
    
    lazy var downBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "down2"), for: .normal)
        btn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var playBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
        btn.setImage(self.pauseImage, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(nextFile), for: .touchUpInside)
        btn.setImage(UIImage(named: "next"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var prevBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(prevFile), for: .touchUpInside)
        btn.setImage(UIImage(named: "previous"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var typeBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(toggleTypePlay), for: .touchUpInside)
        btn.setImage(UIImage(named: "shuffle"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var zoomBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(toggleZoom), for: .touchUpInside)
        btn.setImage(UIImage(named: "zoom"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let playerFrame: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeLeft: UILabel = {
        let lb = UILabel()
        lb.text = "--:--"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 11)
        return lb
    }()
    
    let timeElapsed: UILabel = {
        let lb = UILabel()
        lb.text = "--:--"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 11)
        return lb
    }()
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = "Test"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 3
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.maximumTrackTintColor = .gray
        slider.minimumTrackTintColor = .black
        slider.addTarget(self, action: #selector(slide), for: .valueChanged)
        slider.setThumbImage(UIImage(named: "pig"), for: .normal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var player: AVPlayer?
    var duration: Int!
    var isPlaying = false
    var media: Media?
    var observer: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(downBtn)
        view.addSubview(playBtn)
        view.addSubview(nextBtn)
        view.addSubview(prevBtn)
        view.addSubview(typeBtn)
        view.addSubview(zoomBtn)
        view.addSubview(playerFrame)
        view.addSubview(slider)
        view.addSubview(timeLeft)
        view.addSubview(timeElapsed)
        view.addSubview(label)
        view.addConstraintsWithFormatString(format: "H:|-20-[v0(20)]", views: downBtn)
        view.addConstraintsWithFormatString(format: "V:|-40-[v0(20)]", views: downBtn)
        
        playBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nextBtn.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor).isActive = true
        nextBtn.leftAnchor.constraint(equalTo: playBtn.rightAnchor, constant: 50).isActive = true
        nextBtn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        nextBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        prevBtn.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor).isActive = true
        prevBtn.rightAnchor.constraint(equalTo: playBtn.leftAnchor, constant: -50).isActive = true
        prevBtn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        prevBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        zoomBtn.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -40).isActive = true
        zoomBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        zoomBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        zoomBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeBtn.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -40).isActive = true
        typeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        typeBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        typeBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        slider.bottomAnchor.constraint(equalTo: zoomBtn.topAnchor, constant: -20).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -110).isActive = true
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        timeElapsed.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        timeElapsed.rightAnchor.constraint(equalTo: slider.leftAnchor, constant: -10).isActive = true
        
        timeLeft.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        timeLeft.leftAnchor.constraint(equalTo: slider.rightAnchor, constant: 10).isActive = true
        
        playerFrame.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        playerFrame.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -30).isActive = true
        if (media?.isVideo)! {
            playerFrame.heightAnchor.constraint(equalToConstant: view.frame.width * 9 / 14).isActive = true
        } else {
            playerFrame.heightAnchor.constraint(equalToConstant: view.frame.width * 0.75).isActive = true
            playerFrame.addSubview(imageView)
            playerFrame.addConstraintsWithFormatString(format: "V:|[v0]|", views: imageView)
            playerFrame.addConstraintsWithFormatString(format: "H:|[v0]|", views: imageView)
        }
        
        label.bottomAnchor.constraint(equalTo: playerFrame.topAnchor, constant: -30).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        slider.setValue(0, animated: true)
        let url = URL(fileURLWithPath: (media?.filePath)!)
        player = AVPlayer(url: url)
        player?.play()
        label.text = media?.title
        imageView.image = UIImage(contentsOfFile: (media?.largeImgPath)!)
        let interval = CMTime(value: 1, timescale: 2)
        observer = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            if self.player?.status == .readyToPlay {
                //                self.duration = Int(CMTimeGetSeconds((self.player?.currentItem?.duration)!))
                self.duration = Int(CMTimeGetSeconds((self.player?.currentItem?.asset.duration)!))
                let seconds = Int(CMTimeGetSeconds(progressTime))
                if seconds <= self.duration {
                    self.slider.setValue(Float(seconds)/Float(self.duration), animated: true)
                    self.timeElapsed.text = "\(String(format: "%02d", seconds/60)):\(String(format: "%02d", seconds % 60))"
                    self.timeLeft.text = "\(String(format: "%02d", (self.duration - seconds)/60)):\(String(format: "%02d", (self.duration - seconds)%60))"
                }
            }
            
        })
        isPlaying = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        player?.removeTimeObserver(observer!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hide() {
        dismiss(animated: true, completion: nil)
    }
    
    func togglePlay() {
        if isPlaying {
            player?.pause()
            playBtn.setImage(playImage, for: .normal)
        } else {
            player?.play()
            playBtn.setImage(pauseImage, for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    func nextFile() {
        
    }
    
    func prevFile() {
        
    }
    
    func toggleTypePlay() {
        
    }
    
    func toggleZoom() {
        
    }
    
    func slide() {
        let value = Float64(slider.value) * Float64(duration)
        let seekTime = CMTime(value: Int64(value), timescale: 1)
        player?.seek(to: seekTime, completionHandler: { (completedSeek) in
            
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
