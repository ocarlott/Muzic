//
//  PlayerController.swift
//  Muzic
//
//  Created by Michael Ngo on 1/25/17.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import MuzicFramework
import CoreData

class PlayerController: UIViewController {
    
    // Variables
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    let playImage = UIImage(named: "play")?.withRenderingMode(.alwaysTemplate)
    
    let pauseImage = UIImage(named: "pause")?.withRenderingMode(.alwaysTemplate)
    
    let shuffleType = UIImage(named: "shuffle")?.withRenderingMode(.alwaysTemplate)
    
    let repeatType = UIImage(named: "repeat")?.withRenderingMode(.alwaysTemplate)
    
    lazy var downBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "down2")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var playBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(togglePlay), for: .touchUpInside)
        btn.setImage(self.pauseImage, for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var nextBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(nextFile), for: .touchUpInside)
        btn.setImage(UIImage(named: "next")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var prevBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(prevFile), for: .touchUpInside)
        btn.setImage(UIImage(named: "previous")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var typeBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(toggleTypePlay), for: .touchUpInside)
        btn.tintColor = .white
        btn.setImage(self.shuffleType, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var zoomBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(toggleZoom), for: .touchUpInside)
        btn.setImage(UIImage(named: "zoom")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var timerBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(addTimer), for: .touchUpInside)
        btn.setImage(UIImage(named: "timer")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var favBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(toggleFav), for: .touchUpInside)
        btn.setImage(UIImage(named: "heart")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .white
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
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 11)
        return lb
    }()
    
    let timeElapsed: UILabel = {
        let lb = UILabel()
        lb.text = "--:--"
        lb.textColor = .white
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 11)
        return lb
    }()
    
    let label: UILabel = {
        let lb = UILabel()
        lb.text = " "
        lb.textColor = .white
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
        let image = UIImage(named: "thumb")
        slider.setThumbImage(image!, for: .normal)
        slider.setThumbImage(UIImage(named: "thumbpressed")!, for: .highlighted)
        slider.minimumTrackTintColor = .white
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        picker.backgroundColor = .black
        picker.setValue(UIColor.white, forKey: "textColor")
        return picker
    }()
    
    let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(setTimer))
    
    let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimer))
    
    let flexspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    let toolbar = UIToolbar()
    
    var player = AVPlayer()
    var currentItem: AVPlayerItem?
    var duration: Int!
    var isPlaying = false
    var forcePlay = false
    var lastId: String?
    var playlist: List<Item>?
    var observer: Any!
    var playerLayer: AVPlayerLayer!
    let defaults = UserDefaults(suiteName: "group.appdev")
    var isRepeat = false
    var hour, minute, second: Int!
    var timer: Date!
    let calendar = Calendar.current
    var context: NSManagedObjectContext?
    
}

extension PlayerController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(downBtn)
        view.addSubview(playBtn)
        view.addSubview(nextBtn)
        view.addSubview(prevBtn)
        view.addSubview(typeBtn)
        view.addSubview(zoomBtn)
        view.addSubview(timerBtn)
        view.addSubview(playerFrame)
        view.addSubview(slider)
        view.addSubview(timeLeft)
        view.addSubview(timeElapsed)
        view.addSubview(label)
        view.addSubview(timePicker)
        view.addSubview(favBtn)
        view.addConstraintsWithFormatString(format: "H:|-20-[v0(30)]", views: downBtn)
        view.addConstraintsWithFormatString(format: "V:|-40-[v0(30)]", views: downBtn)
        
        playBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 90).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        nextBtn.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor).isActive = true
        nextBtn.leftAnchor.constraint(equalTo: playBtn.rightAnchor, constant: 50).isActive = true
        nextBtn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        nextBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        prevBtn.centerYAnchor.constraint(equalTo: playBtn.centerYAnchor).isActive = true
        prevBtn.rightAnchor.constraint(equalTo: playBtn.leftAnchor, constant: -50).isActive = true
        prevBtn.widthAnchor.constraint(equalToConstant: 35).isActive = true
        prevBtn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        zoomBtn.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -25).isActive = true
        zoomBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        zoomBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        zoomBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        typeBtn.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -25).isActive = true
        typeBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        typeBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        typeBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        timerBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -45).isActive = true
        timerBtn.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -25).isActive = true
        timerBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        timerBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        favBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 45).isActive = true
        favBtn.bottomAnchor.constraint(equalTo: playBtn.topAnchor, constant: -25).isActive = true
        favBtn.widthAnchor.constraint(equalToConstant: 20).isActive = true
        favBtn.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        slider.bottomAnchor.constraint(equalTo: zoomBtn.topAnchor, constant: -20).isActive = true
        slider.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -110).isActive = true
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        timeElapsed.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        timeElapsed.rightAnchor.constraint(equalTo: slider.leftAnchor, constant: -10).isActive = true
        
        timeLeft.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
        timeLeft.leftAnchor.constraint(equalTo: slider.rightAnchor, constant: 10).isActive = true
        
        playerFrame.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        playerFrame.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -25).isActive = true
        playerFrame.heightAnchor.constraint(equalToConstant: view.frame.width * 9 / 16).isActive = true
        playerFrame.addSubview(imageView)
        playerFrame.clipsToBounds = true
        playerFrame.addConstraintsWithFormatString(format: "V:|[v0]|", views: imageView)
        playerFrame.addConstraintsWithFormatString(format: "H:|[v0]|", views: imageView)
        
        label.bottomAnchor.constraint(equalTo: playerFrame.topAnchor, constant: -20).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        
        view.addConstraintsWithFormatString(format: "V:[v0(220)]|", views: timePicker)
        view.addConstraintsWithFormatString(format: "H:|[v0]|", views: timePicker)
        timePicker.isHidden = true
        
        doneBtn.tintColor = .white
        cancelBtn.tintColor = .white
        toolbar.setItems([cancelBtn, flexspace, doneBtn], animated: false)
        view.addSubview(toolbar)
        toolbar.barTintColor = .black
        view.addConstraintsWithFormatString(format: "H:|[v0]|", views: toolbar)
        view.addConstraintsWithFormatString(format: "V:[v0(35)]-220-|", views: toolbar)
        toolbar.isHidden = true
        view.backgroundColor = .black
        
        if (defaults?.bool(forKey: "isRepeat"))! {
            typeBtn.setImage(self.repeatType, for: .normal)
            isRepeat = true
        }
        
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(nextFile))
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(prevFile))
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(play))
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action: #selector(pause))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObserverForTracking()
        if playlist?.getCurrentKey().id != lastId {
            loadFiles()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (playlist?.getCurrentKey().id != lastId) {
            loadViews()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.removeTimeObserver(observer!)
        observer = nil
        defaults?.set(isRepeat, forKey: "isRepeat")
    }
    
}

extension PlayerController {
    
    // Methods
    
    func loadFiles() {
        currentItem = AVPlayerItem(url: URL(fileURLWithPath: (playlist?.getCurrentKey().filePath)!))
        currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        player.replaceCurrentItem(with: currentItem)
    }
    
    func loadViews() {
        if (playlist?.getCurrentKey().isVideo)! {
            imageView.alpha = 0
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = CGRect(x: 0, y: 0, width: playerFrame.frame.width, height: playerFrame.frame.height)
            playerFrame.layer.addSublayer(playerLayer)
        } else {
            imageView.alpha = 1
            if playerLayer != nil {
                playerLayer.isHidden = true
            }
            imageView.image = UIImage(contentsOfFile: (playlist?.getCurrentKey().imgPath)!)
        }
        if (playlist?.getCurrentKey().isFavorited)! {
            favBtn.tintColor = .red
        } else {
            favBtn.tintColor = .white
        }
        label.text = playlist?.getCurrentKey().title
        playBtn.setImage(pauseImage, for: .normal)
        lastId = playlist?.getCurrentKey().id
    }
    
    @objc func play() {
        do {
            UIApplication.shared.beginReceivingRemoteControlEvents()
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error {
            print(error)
        }
        addObserverForTracking()
        let infoCenter = MPNowPlayingInfoCenter.default()
        let image = UIImage(contentsOfFile: (playlist?.getCurrentKey().imgPath)!)!
        let artwork = MPMediaItemArtwork.init(boundsSize: image.size, requestHandler: { (size) -> UIImage in
            return image
        })
        let duration = NSNumber(value: Int(CMTimeGetSeconds((self.player.currentItem?.asset.duration)!)))
        infoCenter.nowPlayingInfo = [MPMediaItemPropertyTitle: (playlist?.getCurrentKey().title)!,
                                     MPMediaItemPropertyArtwork: artwork,
                                     MPMediaItemPropertyPlaybackDuration: duration,
                                     MPNowPlayingInfoPropertyElapsedPlaybackTime: NSNumber(value: Int(CMTimeGetSeconds((currentItem?.currentTime())!))),
                                     MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1.0)]
        player.play()
        isPlaying = true
    }
    
    func addObserverForTracking() {
        if observer == nil {
            let interval = CMTime(value: 1, timescale: 2)
            observer = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                self.duration = Int(CMTimeGetSeconds((self.player.currentItem?.asset.duration)!))
                let seconds = Int(CMTimeGetSeconds(progressTime))
                if seconds <= self.duration {
                    self.slider.setValue(Float(seconds)/Float(self.duration), animated: true)
                    self.timeElapsed.text = "\(String(format: "%02d", seconds/60)):\(String(format: "%02d", seconds % 60))"
                    self.timeLeft.text = "\(String(format: "%02d", (self.duration - seconds)/60)):\(String(format: "%02d", (self.duration - seconds)%60))"
                    if seconds == self.duration && seconds != 0 && self.isPlaying {
                        self.isPlaying = false
                        self.nextAction()
                    }
                }
            })
        }
    }
    
    func nextAction() {
        self.observer = nil
        if self.isRepeat {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                if self.isRepeat {
                    self.slider.setValue(0, animated: true)
                    self.play()
                }
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                if !self.isRepeat {
                    self.nextFile()
                }
            })
        }
    }
    
    @objc func pause() {
        player.pause()
        isPlaying = false
    }
    
    @objc func hide() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func togglePlay() {
        if isPlaying {
            player.pause()
            playBtn.setImage(playImage, for: .normal)
        } else {
            player.play()
            playBtn.setImage(pauseImage, for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    @objc func nextFile() {
        playlist?.next()
        loadFiles()
        loadViews()
        play()
    }
    
    @objc func prevFile() {
        playlist?.prev()
        loadFiles()
        loadViews()
        play()
    }
    
    @objc func toggleTypePlay() {
        if isRepeat {
            typeBtn.setImage(self.shuffleType, for: .normal)
        } else {
            typeBtn.setImage(self.repeatType, for: .normal)
        }
        isRepeat = !isRepeat
    }
    
    @objc func toggleZoom() {
        let avPlayerVC = CustomAVPlayerVC()
        let url = URL(fileURLWithPath: (playlist?.getCurrentKey().filePath)!)
        let playerFull = AVPlayer(url: url)
        player.seek(to: CMTime(seconds: 0, preferredTimescale: 1))
        playBtn.setImage(playImage, for: .normal)
        slider.setValue(0, animated: false)
        player.pause()
        avPlayerVC.player = playerFull
        present(avPlayerVC, animated: true, completion: {
            playerFull.play()
        })
    }
    
    @objc func slide() {
        let value = Float64(slider.value) * Float64(duration)
        let seekTime = CMTime(value: Int64(value), timescale: 1)
        player.seek(to: seekTime)
    }
    
    @objc func addTimer() {
        timePicker.isHidden = false
        toolbar.isHidden = false
    }
    
    @objc func setTimer() {
        timePicker.isHidden = true
        toolbar.isHidden = true
        timerBtn.tintColor = .blue
        timer = Date().addingTimeInterval(timePicker.countDownDuration)
        hour = calendar.component(.hour, from: timer)
        minute = calendar.component(.minute, from: timer)
        second = calendar.component(.second, from: timer)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(self.timePicker.countDownDuration)), execute: {
            let pTime = Date()
            let pHour = self.calendar.component(.hour, from: pTime)
            let pMinute = self.calendar.component(.minute, from: pTime)
            let pSecond = self.calendar.component(.second, from: pTime)
            if pHour == self.hour && pMinute == self.minute && pSecond >= self.second - 5 && pSecond <= self.second + 5 {
                self.player.pause()
                self.timerBtn.tintColor = .black
                self.timer = nil
                self.playBtn.setImage(self.playImage, for: .normal)
            }
        })
    }
    
    @objc func cancelTimer() {
        timePicker.isHidden = true
        toolbar.isHidden = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                play()
                currentItem?.removeObserver(self, forKeyPath: keyPath!)
                break
            case .failed:
                break
            case .unknown:
                break
            }
        }
    }
    
    @objc func toggleFav() {
        if (playlist?.getCurrentKey().isFavorited)! {
            favBtn.tintColor = .white
        } else {
            favBtn.tintColor = .red
        }
        playlist?.getCurrentKey().isFavorited = !(playlist?.getCurrentKey().isFavorited)!
        do {
            try context?.save()
        } catch {
            print("Cannot save favorite item")
        }
        FavoriteVC.shouldUpdateFavorite = true
    }

}
