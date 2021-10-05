//
//  AlertViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

class AlertViewController: UIViewController {
    
    private lazy var alertView = AlertView()
    private lazy var nameAlertAnimation = String()
    private lazy var textAlertMessage = String()
    private lazy var nextButton = RoundedButton()
    private lazy var previewButton = RoundedButton()
    
    convenience init(nameAlertAnimation: String, textAlertMessage: String) {
        self.init()
        self.nameAlertAnimation = nameAlertAnimation
        self.textAlertMessage = textAlertMessage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView = AlertView(nameAlertAnimation: nameAlertAnimation, textAlertMessage: textAlertMessage)
       // transitionSearch()
    }
    
    override func loadView() {
        self.view = alertView
    }
    
    func transitionSearch() {
        Timer.scheduledTimer(timeInterval: 4.0,
                             target: self,
                             selector: #selector(timerWork),
                             userInfo: nil,
                             repeats: false)
    }
    
    @objc func timerWork() {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "search")
                as? SearchViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }
}
