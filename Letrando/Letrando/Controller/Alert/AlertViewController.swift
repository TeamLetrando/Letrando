//
//  AlertViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

class AlertViewController: UIViewController {
    
    @IBOutlet var alertView: UIView!
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
//        let storyboard = UIStoryboard(name: "Search", bundle: nil)
//        guard let viewC =  storyboard.instantiateViewController(identifier: "search")
//                as? SearchViewController else {fatalError()}
//        viewC.modalPresentationStyle = .fullScreen
//        self.present(viewC, animated: true, completion: nil)
        
        let controller = SearchViewController()
        self.present(controller, animated: true, completion: nil)
    }
}
