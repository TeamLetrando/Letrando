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
    var bar = [
        ("Seg", 20.0),
        ("Ter", 30.0),
        ("Qua", 2.0),
        ("Qui", 7.0),
        ("Sex", 15.0),
        ("Sab", 50.0),
        ("Dom", 45.0)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawGraphic()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func drawGraphic() {
        let axisX = self.acessGraphicView.bounds.width
        let axisY = self.acessGraphicView.bounds.height
        let minX = self.acessGraphicView.bounds.minX
        let minY = self.acessGraphicView.bounds.minY
        
        let settings = configureGraphic()
        
        let labelSettings = configureLabelLines()
        
        let lines = GuidelinesConfig(dotted: false, lineWidth: 0.2, lineColor: UIColor.bronwLetters)
        
        let chartConfig = BarsChartConfig(
            chartSettings: settings,
            valsAxisConfig: ChartAxisConfig(from: 0, to: 50, by: 10),
            xAxisLabelSettings: labelSettings,
            yAxisLabelSettings: labelSettings,
            guidelinesConfig: lines)
        
        let chart = BarsChart(
            frame: CGRect(x: minX, y:minY, width: axisX , height: axisY),
            chartConfig: chartConfig,
            xTitle: "Dias da Semana",
            yTitle: "Total de palavras",
            bars: self.bar,
            color: UIColor.purpleLetters,
            barWidth: self.acessGraphicView.bounds.width/7 - 15
        )
        self.acessGraphicView.addSubview(chart.view)
        self.chartView = chart
    }
    
    func configureGraphic() -> ChartSettings {
        var settings = ChartSettings()
        settings.top = 15.0
        settings.bottom = 10.0
        settings.leading = 10.0
        settings.trailing = 10.0
        settings.labelsToAxisSpacingX = 5
        settings.labelsToAxisSpacingY = 5
        settings.axisTitleLabelsToLabelsSpacing = 4
        settings.axisStrokeWidth = 0.2
        settings.spacingBetweenAxesX = 8
        settings.spacingBetweenAxesY = 8
        settings.labelsSpacing = 0
        settings.zoomPan.zoomEnabled = false
        settings.zoomPan.panEnabled = true
        
        return settings
    }
    
    func configureLabelLines() -> ChartLabelSettings {
        var labelSettings = ChartLabelSettings()
        labelSettings.fontColor = UIColor.bronwLetters
        labelSettings.font = UIFont.systemFont(ofSize: 17)
        return labelSettings
    }
    
}
