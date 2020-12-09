//
//  HomeViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import Lottie
import AVFoundation

class HomeViewController: UIViewController {
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    var sound = Sounds()
    var music = AVPlayer()
    @IBOutlet weak var soundButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Report.readReports()
        animateDog()
        configureInitalLabel()
        guard let musicBackgroud = AVPlayer(name: "Curious_Kiddo", extension: "mp3") else {return}
        self.music = musicBackgroud
        
        if UserDefaults.standard.bool(forKey: "Launch") {
            if sound.checkAudio() {
                soundButton.setImage(UIImage(named: "audio"), for: .normal)
                music.playLoop()
            } else {
                soundButton.setImage(UIImage(named: "audioOff"), for: .normal)
                music.endLoop()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
            if sound.checkAudio() {
                soundButton.setImage(UIImage(named: "audio"), for: .normal)
                music.playLoop()
            } else {
                soundButton.setImage(UIImage(named: "audioOff"), for: .normal)
                music.endLoop()
            }
    }
    
    func animateDog() {
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.8
        animationView.play()
    }

    override func viewDidAppear(_ animated: Bool) {
        animationView.play()
    }

    func configureInitalLabel() {
        initialLabel.textColor = .bronwLetters
        guard let customFont = UIFont(name: "BubblegumSans-Regular", size: 60) else {
            fatalError("""
                Failed to load the "BubblegumSans-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        initialLabel.font = UIFontMetrics.default.scaledFont(for: customFont)
        initialLabel.adjustsFontForContentSizeCategory = true
    }

    @IBAction func search(_ sender: Any) {
        music.endLoop()
        let storyboard = UIStoryboard(name: "Alert", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "alert")
                as? AlertViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }
    
    @IBAction func reportButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Report", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "report")
                as? ReportViewController else {fatalError()}
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
