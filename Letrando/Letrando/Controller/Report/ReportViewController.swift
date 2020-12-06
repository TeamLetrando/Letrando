//
//  ReportViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import SwiftCharts

class ReportViewController: UIViewController {

    @IBOutlet weak var rangeWords: UILabel!
    @IBOutlet weak var knowWords: UILabel!
    @IBOutlet weak var rankView: UIView!
    @IBOutlet weak var acessGraphicView: UIView!
    
    var chartView: BarsChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let chartConfig = BarsChartConfig(valsAxisConfig: ChartAxisConfig(from: 0, to: 50, by: 10))
        
        let axisX = self.acessGraphicView.bounds.width - 15
        let axisY = self.acessGraphicView.bounds.height + 30
        let minX = self.acessGraphicView.bounds.minX + 10
        let minY = self.acessGraphicView.bounds.minY + 10

        let chart = BarsChart(
            frame: CGRect(x: minX, y:minY, width: axisX , height: axisY),
            chartConfig: chartConfig,
            xTitle: "Dias da Semana",
            yTitle: "Total de palavras",
            bars: [
                ("Seg", 20),
                ("Ter", 30),
                ("Qua", 2),
                ("Qui", 7),
                ("Sex", 15),
                ("Sab", 50),
                ("Dom", 45)
            ],
            color: UIColor.purpleLetters,
            barWidth: self.acessGraphicView.bounds.width/7 - 15
        )
        
        self.acessGraphicView.addSubview(chart.view)
        self.chartView = chart
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
