//
//  ReportViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import CoreGraphics

class ReportViewController: UIViewController {

    @IBOutlet weak var rangeWords: UILabel!
    @IBOutlet weak var knowWords: UILabel!
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var acessGraphicView: UIView!
    @IBOutlet weak var rangeWordsView: UIView!
    @IBOutlet weak var knowWordsView: UIView!
    
    @IBOutlet weak var acessGraphicImageView: UIImageView!
    @IBOutlet weak var rankGraphicView: UIImageView!
    var bar: [CGFloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var ranking: [String]? = ["","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeWords.text = "\(Report.mediaOfWordsInWeek() ?? 0)"
        knowWords.text = "\(Report.numberOfLearnedWords() ?? 0)"
        getBar()
        getRank()
        acessGraphicView.layer.cornerRadius = 20.0
        rankView.layer.cornerRadius = 20.0
        rangeWordsView.layer.cornerRadius = 20.0
        knowWordsView.layer.cornerRadius = 20.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rangeWords.text = "\(Report.mediaOfWordsInWeek() ?? 0)"
        knowWords.text = "\(Report.numberOfLearnedWords() ?? 0)"
        getBar()
        getRank()
        drawGraphic()
        drawRanking()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func drawRanking() {
        let renderer = UIGraphicsImageRenderer(size: rankGraphicView.frame.size)

            let img = renderer.image {context in
                let viewWidth:CGFloat = rankGraphicView.frame.size.width
                let viewHeight:CGFloat = rankGraphicView.frame.size.height
                
                let cellLength: CGFloat = viewWidth * 0.15
                
                let xRect1: CGFloat = (viewWidth/4) + cellLength
                let yRect1: CGFloat = viewHeight * 0.2
                let xRect2: CGFloat = (viewWidth/4)
                let yRect2: CGFloat = viewHeight * 0.35
                let xRect3: CGFloat = (viewWidth/4) + 2 * cellLength
                let yRect3: CGFloat = viewHeight * 0.6
                
                guard let font = UIFont(name: "BubblegumSans-Regular", size: 40.0) else {return}
                guard let fontWords = UIFont(name: "BubblegumSans-Regular", size: 20.0) else {return}
                let fontTitle = UIFont.boldSystemFont(ofSize: 22.0)
                
                context.cgContext.setFillColor(UIColor.purpleLetters.cgColor)
                context.cgContext.fill([
                    CGRect(x: xRect1, y: yRect1, width: cellLength, height: 0.75 * viewHeight),
                    CGRect(x: xRect2, y: yRect2, width: cellLength, height: 0.6 * viewHeight),
                    CGRect(x: xRect3, y: yRect3, width: cellLength, height: 0.35 * viewHeight)
                ])
                // swiftlint:disable all
                let atts = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.whiteViews]
                let attsWords = [ NSAttributedString.Key.font: fontWords, NSAttributedString.Key.foregroundColor: UIColor.bronwLetters]
                let attsTitle = [ NSAttributedString.Key.font: fontTitle, NSAttributedString.Key.foregroundColor: UIColor.bronwLetters]
                ("1" as NSString).draw(at:CGPoint(x: xRect1 + (cellLength / 2.15), y: 0.60 * viewHeight), withAttributes: atts)
                ((ranking?[0] ?? "") as NSString).draw(at:CGPoint(x: 1.03 * xRect1, y: viewHeight * 0.12), withAttributes: attsWords)
                ("2" as NSString).draw(at:CGPoint(x: xRect2 + (cellLength / 2.15), y: 0.675 * viewHeight), withAttributes: atts)
                ((ranking?[1] ?? "") as NSString).draw(at:CGPoint(x: 1.03 * xRect2, y: viewHeight * 0.27), withAttributes: attsWords)
                ("3" as NSString).draw(at:CGPoint(x: xRect3 + (cellLength / 2.15), y: 0.75 * viewHeight), withAttributes: atts)
                ((ranking?[2] ?? "") as NSString).draw(at:CGPoint(x: 1.03 * xRect3, y: viewHeight * 0.52), withAttributes: attsWords)
                ("Ranking de Palavras" as NSString).draw(at:CGPoint(x: (viewWidth/5), y: 0.0), withAttributes: attsTitle)
            }
            rankGraphicView.image = img
    }
    
    func drawGraphic() {
    // swiftlint:enable all

        let renderer = UIGraphicsImageRenderer(size: acessGraphicImageView.frame.size)

            let img = renderer.image {context in
                let viewWidth:CGFloat = acessGraphicImageView.frame.size.width
                let viewHeight:CGFloat = acessGraphicImageView.frame.size.height - 55.0
                
                let cellLength: CGFloat = viewWidth * 0.1
                
                let xRect1: CGFloat = (viewWidth/6)
                let yRect1: CGFloat = (viewHeight * (1 - self.bar[0])) + 30
                let xRect2: CGFloat = (viewWidth/6) + cellLength
                let yRect2: CGFloat = (viewHeight * (1 - self.bar[1])) + 30
                let xRect3: CGFloat = (viewWidth/6) + 2 * cellLength
                let yRect3: CGFloat = (viewHeight * (1 - self.bar[2])) + 30
                let xRect4: CGFloat = (viewWidth/6) + 3 * cellLength
                let yRect4: CGFloat = (viewHeight * (1 - self.bar[3])) + 30
                let xRect5: CGFloat = (viewWidth/6) + 4 * cellLength
                let yRect5: CGFloat = (viewHeight * (1 - self.bar[4])) + 30
                let xRect6: CGFloat = (viewWidth/6) + 5 * cellLength
                let yRect6: CGFloat = (viewHeight * (1 - self.bar[5])) + 30
                let xRect7: CGFloat = (viewWidth/6) + 6 * cellLength
                let yRect7: CGFloat = (viewHeight * (1 - self.bar[6])) + 30
                
                context.cgContext.setFillColor(UIColor.purpleLetters.cgColor)
                context.cgContext.fill([
                    CGRect(x: xRect1, y: yRect1, width: cellLength, height: (self.bar[0]) * viewHeight),
                    CGRect(x: xRect2, y: yRect2, width: cellLength, height: (self.bar[1]) * viewHeight),
                    CGRect(x: xRect3, y: yRect3, width: cellLength, height: (self.bar[2]) * viewHeight),
                    CGRect(x: xRect4, y: yRect4, width: cellLength, height: (self.bar[3]) * viewHeight),
                    CGRect(x: xRect5, y: yRect5, width: cellLength, height: (self.bar[4]) * viewHeight),
                    CGRect(x: xRect6, y: yRect6, width: cellLength, height: (self.bar[5]) * viewHeight),
                    CGRect(x: xRect7, y: yRect7, width: cellLength, height: (self.bar[6]) * viewHeight)
                ])

                context.cgContext.setStrokeColor(UIColor.bronwLetters.cgColor)
                context.cgContext.setLineWidth(2.0)
                // swiftlint:disable all
                context.cgContext.addLines(between: [CGPoint(x: xRect1, y: viewHeight + 30), CGPoint(x: xRect7 + cellLength + 20, y: viewHeight + 30)])
                context.cgContext.addLines(between: [CGPoint(x: xRect7 + cellLength + 20, y: viewHeight + 30), CGPoint(x: xRect7 + cellLength + 15, y: viewHeight + 35)])
                context.cgContext.addLines(between: [CGPoint(x: xRect7 + cellLength + 20, y: viewHeight + 30), CGPoint(x: xRect7 + cellLength + 15, y: viewHeight + 25)])
                context.cgContext.addLines(between: [CGPoint(x: xRect1, y: viewHeight + 30), CGPoint(x: xRect1, y: 25)])
                context.cgContext.addLines(between: [CGPoint(x: xRect1, y: 25), CGPoint(x: xRect1 - 5, y: 30)])
                context.cgContext.addLines(between: [CGPoint(x: xRect1, y: 25), CGPoint(x: xRect1 + 5 , y: 30)])
                context.cgContext.strokePath()

                let fontWords = UIFont.systemFont(ofSize: 17.0)
                let fontTitle = UIFont.boldSystemFont(ofSize: 22.0)
                
                let attsWords = [ NSAttributedString.Key.font: fontWords, NSAttributedString.Key.foregroundColor: UIColor.bronwLetters]
                let attsTitle = [ NSAttributedString.Key.font: fontTitle, NSAttributedString.Key.foregroundColor: UIColor.bronwLetters]
                ("Percentual de Palavras por dia" as NSString).draw(at:CGPoint(x: (viewWidth/8), y: 0.0), withAttributes: attsTitle)
                ("Dom" as NSString).draw(at:CGPoint(x: xRect1 + (cellLength/8), y: viewHeight + 32), withAttributes: attsWords)
                ("Seg" as NSString).draw(at:CGPoint(x: xRect2 + (cellLength/8), y: viewHeight + 32), withAttributes: attsWords)
                ("Ter" as NSString).draw(at:CGPoint(x: xRect3 + (cellLength/8), y: viewHeight + 32), withAttributes: attsWords)
                ("Qua" as NSString).draw(at:CGPoint(x: xRect4 + (cellLength/8), y: viewHeight + 32), withAttributes: attsWords)
                ("Qui" as NSString).draw(at:CGPoint(x: xRect5 + (cellLength/8), y: viewHeight + 32), withAttributes: attsWords)
                ("Sex" as NSString).draw(at:CGPoint(x: xRect6 + (cellLength/8), y: viewHeight + 32), withAttributes: attsWords)
                ("Sab" as NSString).draw(at:CGPoint(x: xRect7 + (cellLength/8), y: viewHeight + 32), withAttributes: attsWords)

                ("100%" as NSString).draw(at:CGPoint(x: xRect1 - (cellLength * 1.2), y: 30), withAttributes: attsWords)
                ("80%" as NSString).draw(at:CGPoint(x: xRect1 - (cellLength * 1.2), y: viewHeight * 0.2 + 30), withAttributes: attsWords)
                ("60%" as NSString).draw(at:CGPoint(x: xRect1 - (cellLength * 1.2), y: viewHeight * 0.4 + 30), withAttributes: attsWords)
                ("40%" as NSString).draw(at:CGPoint(x: xRect1 - (cellLength * 1.2), y: viewHeight * 0.6 + 30), withAttributes: attsWords)
                ("20%" as NSString).draw(at:CGPoint(x: xRect1 - (cellLength * 1.2), y: viewHeight * 0.8 + 30), withAttributes: attsWords)
                // swiftlint:enable all
         }
            acessGraphicImageView.image = img
    }
    
    func getBar() {
        guard let workADay = Report.getWordsADay(), let learnedWords = Report.numberOfLearnedWords() else {
            bar = []
            return
        }
        
        for index in 0...6 {
            bar.insert(((CGFloat(workADay[index])) / CGFloat(learnedWords)), at: index)
        }
    }
    
    func getRank() {
        guard let report = Report.getMostSearchWords() else {
            ranking = nil
            return
        }

        for index in 0...2 {
            ranking?.insert(report[index], at: index)
        }
    }
}
