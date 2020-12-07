//
//  Sounds.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import Foundation
import AVFoundation

struct Sounds {
    
    var player = AVAudioPlayer()
    
    mutating func setupPlayer (name:String, formato:String) -> AVAudioPlayer {
        let sound = Bundle.main.path(forResource: name, ofType: formato)
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        } catch {
            print(error)
        }
        return player
    }
    
    mutating func myAudio () -> AVAudioPlayer {
        return setupPlayer(name: "Curious_Kiddo", formato: "mp3")
    }
    
    mutating func checkAudio() -> Bool {
        if UserDefaults.standard.bool(forKey: "checkSound") == true {
            return true
        } else {
            return false
        }
    }
}
