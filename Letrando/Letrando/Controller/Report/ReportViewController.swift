//
//  ReportViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var rangeWords: UILabel!
    @IBOutlet weak var knowWords: UILabel!
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var acessGraphicView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
