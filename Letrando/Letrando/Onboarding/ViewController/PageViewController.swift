//
//  PageViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

protocol PageViewControllerProtocol: UIViewController {
    func setup(with view: PageView)
}

class PageViewController: UIViewController, PageViewControllerProtocol {
  
    private let transitionTime = CGFloat(3)
    private var alertView: PageView?
    weak var delegate: PageViewDelegate?
  
    func setup(with view: PageView) {
        self.alertView = view
    }
    
    override func loadView() {
        delegate = alertView
        self.view = alertView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.startAnimation()
    }
}

extension PageViewController: PageViewDelegate {
    
    func startAnimation() {
        delegate?.startAnimation()
        view.layoutIfNeeded()
    }
}
