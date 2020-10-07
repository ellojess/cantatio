//
//  AudioController.swift
//  cantatio
//
//  Created by Jessica Trinh on 10/7/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import AVFoundation


class AudioController {
    public static var shared = AudioController()
    
    public var player = AVAudioPlayer()
    
    var previewURL = String()

    func initPlayer(url : String) {
        guard let url = URL.init(string: url) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVAudioPlayer.init()
        playAudioBackground()
    }
    
    func playAudioBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
            
//            player.play()
            
        } catch {
            print(error)
        }
    }
    
    func pause(){
        player.pause()
    }

    
    func play(url: URL){
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            // play song even if phone is on silent
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            
            player.prepareToPlay()
            player.volume = 1
            player.play()

        } catch let error as NSError {
            print(error)
        }
    }
    
    
    func downloadFileFromURL(url: URL){
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            customURL, response, error in
            
            self.play(url: customURL!)
            
        })
        
        downloadTask.resume()
        
    }
    
    
    
}

// reference: https://stackoverflow.com/questions/48555049/how-to-stream-audio-from-url-without-downloading-mp3-file-on-device/53568482
//https://www.youtube.com/watch?v=AMQ4QxZRal0&list=PL3MWPU0RhJzFc_itFVd-UxoBdu0NBY8uU&index=3
