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
    weak var delegate: AlertViewDelegate?
    private lazy var nameAlertAnimation = String()
    private lazy var textAlertMessage = String()
    
    convenience init(nameAlertAnimation: String, textAlertMessage: String) {
        self.init()
        self.nameAlertAnimation = nameAlertAnimation
        self.textAlertMessage = textAlertMessage
    }
    
    
    func setup(with view: AlertView, alertRouter: AlertRouterLogic) {
        self.alertView = view
        self.alertRouter = alertRouter
    }
    
    override func loadView() {
        alertView = AlertView(nameAlertAnimation: nameAlertAnimation, textAlertMessage: textAlertMessage)
        delegate = alertView
        self.view = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionToGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.startAnimation()
    }
    
    func transitionToGame() {
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionTime) { [weak self] in
            self?.alertRouter?.startGame()
        }
    }
}

extension AlertViewController: AlertViewDelegate {
    
    func startAnimation() {
        delegate?.startAnimation()
        view.layoutIfNeeded()
    }
}
