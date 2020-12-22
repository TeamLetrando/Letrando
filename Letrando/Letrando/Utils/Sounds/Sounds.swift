//
//  Sounds.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import Foundation
import AVFoundation

class Sounds {
    
    static var audioPlayer: AVAudioPlayer?
    
    static func checkAudio() -> Bool {
        if UserDefaults.standard.bool(forKey: "checkSound") == true {
            return true
        } else {
            return false
        }
    }
        static func playAudio() {
            do {
                let audioSession = AVAudioSession.sharedInstance()
                //try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
                try audioSession.setCategory(.ambient)
                try audioSession.setActive(true)
                
                guard let url = Bundle.main.url(forResource: "Curious_Kiddo", withExtension: "mp3") else {return}
                Sounds.audioPlayer = try? AVAudioPlayer(contentsOf: url)
                Sounds.audioPlayer?.numberOfLoops = -1
                Sounds.audioPlayer?.prepareToPlay()
                Sounds.audioPlayer?.play()
            } catch {
                print("Failed to set audio session category.")
            }
        }
        
        static func audioFinish() {
            Sounds.audioPlayer?.stop()
           }
}
