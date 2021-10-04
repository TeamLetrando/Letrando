//
//  AlertViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

class AlertViewController: UIViewController {
    
    private lazy var alertView = AlertView()
    
    override func loadView() {
        self.view = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionSearch()
    }
    
    func transitionSearch() {
        Timer.scheduledTimer(timeInterval: 4.0,
                             target: self,
                             selector: #selector(timerWork),
                             userInfo: nil,
                             repeats: false)
    }
    
    @objc func timerWork() {
        let controller = SearchViewController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}
