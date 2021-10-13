//
//  AlertViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

class AlertViewController: UIViewController {
    
    weak var delegate: AlertViewDelegate?
    private lazy var alertView = AlertView()
    private lazy var nameAlertAnimation = String()
    private lazy var textAlertMessage = String()
    
    convenience init(nameAlertAnimation: String, textAlertMessage: String) {
        self.init()
        self.nameAlertAnimation = nameAlertAnimation
        self.textAlertMessage = textAlertMessage
    }
    
    override func loadView() {
        alertView = AlertView(nameAlertAnimation: nameAlertAnimation, textAlertMessage: textAlertMessage)
        delegate = alertView
        self.view = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.startAnimation()
    }
    
    func starAnimation() {
        delegate?.startAnimation()
        view.layoutIfNeeded()
    }
}
