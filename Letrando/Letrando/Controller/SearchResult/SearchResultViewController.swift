//
//  SearchResultViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import Lottie
import AVFoundation
import ARKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var mensageLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var outButton: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var soundButton: UIButton!
    var wordResult: String = "LABEL"
    var sound = Sounds()
    var music = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayoutOfItems()
        animateDog()
        
        guard let musicBackgroud = AVPlayer(name: "Curious_Kiddo", extension: "mp3") else {return}
        self.music = musicBackgroud
        if sound.checkAudio() {
            music.playLoop()
        } else {
            music.endLoop()
        }
        Report.createReport(word: wordLabel.text!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
        reproduceSound(string: wordResult)
        
        if sound.checkAudio() {
            soundButton.setImage(UIImage(named: "audio"), for: .normal)
        } else {
            soundButton.setImage(UIImage(named: "audioOff"), for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.pause()
    }
    
    func reproduceSound(string: String) {
        let utterance =  AVSpeechUtterance(string: string)
        let voice = AVSpeechSynthesisVoice(language: "pt-BR")
        utterance.voice = voice
        let sintetizer = AVSpeechSynthesizer()
        sintetizer.speak(utterance)
    }

    func animateDog() {
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.8
        animationView.play()
    }

    func setupLayoutOfItems() {
        mensageLabel.textColor = .bronwLetters
        mensageLabel.font = UIFont(name: "BubblegumSans-Regular", size: 60)
        
        wordLabel.textColor = .purpleLetters
        wordLabel.text = wordResult.uppercased()
        wordLabel.font = .systemFont(ofSize: 90)

        searchButton.backgroundColor = .greenButtons
        searchButton.titleLabel?.textColor = .white
        searchButton.titleLabel?.font = UIFont(name: "BubblegumSans-Regular", size: 40)
        searchButton.layer.cornerRadius = 10

        outButton.backgroundColor = .bronwLetters
        outButton.titleLabel?.textColor = .white
        outButton.titleLabel?.font = UIFont(name: "BubblegumSans-Regular", size: 40)
        outButton.layer.cornerRadius = 10
    }

    @IBAction func searchAgain(_ sender: UIButton) {
        self.music.endLoop()
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "search")
                as? SearchViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }

    @IBAction func exitScrenn(_ sender: UIButton) {
        self.music.endLoop()
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "home")
                as? HomeViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }
    
    @IBAction func soundPressed(_ sender: UIButton) {
        switch self.sound.checkAudio() {
        case true:
            sender.setImage(UIImage(named: "audioOff"), for: .normal)
            UserDefaults.standard.set(false, forKey: "checkSound")
            self.music.endLoop()
        default:
            sender.setImage(UIImage(named: "audio"), for: .normal)
            UserDefaults.standard.set(true, forKey: "checkSound")
            self.music.playLoop()
        }
    }
    
}
