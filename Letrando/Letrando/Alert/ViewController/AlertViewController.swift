//
//  AlertViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

protocol AlertViewControllerProtocol: UIViewController {
    func setup(with view: AlertView, alertRouter: AlertRouterLogic)
}

class AlertViewController: UIViewController, AlertViewControllerProtocol {
  
    private let transitionTime = CGFloat(3)
    private var alertView: AlertView?
    private var alertRouter: AlertRouterLogic?
    
    func setup(with view: AlertView, alertRouter: AlertRouterLogic) {
        self.alertView = view
        self.alertRouter = alertRouter
    }
    
    override func loadView() {
        self.view = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionToGame()
    }
    
    func transitionToGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionTime) { [weak self] in
            self?.alertRouter?.startGame()
        }
    }
}
