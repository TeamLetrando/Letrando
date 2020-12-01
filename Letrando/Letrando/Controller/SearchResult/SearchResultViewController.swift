//
//  SearchResultViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var mensageLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var outButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayoutOfItems()
    }

    func setupLayoutOfItems() {
        mensageLabel.textColor = .bronwLetters
        mensageLabel.font = UIFont(name: "BubblegumSans-Regular", size: 60)

        wordLabel.textColor = .purpleLetters
        wordLabel.text = wordLabel.text?.uppercased()
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
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "search")
                as? SearchViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }

    @IBAction func exitScrenn(_ sender: UIButton) {
    }
}
