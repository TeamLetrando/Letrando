//
//  HomeViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import Lottie
class HomeViewController: UIViewController {
    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        animateDog()
        configureInitalLabel()
        // Do any additional setup after loading the view.
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
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "search")
                as? SearchViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }
}
