//
//  AlertViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var text: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.textColor = .bronwLetters
        guard let customFont = UIFont(name: "BubblegumSans-Regular", size: 40) else {
            fatalError("""
                Failed to load the "BubblegumSans-Regular" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        text.font = UIFontMetrics.default.scaledFont(for: customFont)
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
