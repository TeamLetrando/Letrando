//
//  Sounds.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import Foundation
import AVFoundation

struct Sounds {
    mutating func checkAudio() -> Bool {
        if UserDefaults.standard.bool(forKey: "checkSound") == true {
            return true
        } else {
            return false
        }
    }
}

extension AVPlayer {
    convenience init?(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        self.init(playerItem: playerItem)
    }
    convenience init?(name: String, extension ext: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            return nil
        }
        self.init(url: url)
    }
    func playFromStart() {
        seek(to: CMTimeMake(value: 0, timescale: 1))
        play()
    }
    func playLoop() {
        playFromStart()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.currentItem, queue: nil) { notification in
            if self.timeControlStatus == .playing {
                self.playFromStart()
            }
        }
    }
    func endLoop() {
        pause()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self)
    }
}
