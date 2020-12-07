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
    @IBOutlet weak var rangeWordsView: UIView!
    @IBOutlet weak var knowWordsView: UIView!
    var rankChartView: BarsChart!
    var rank = [
        ("Bola", 30.0),
        ("Amor", 40.0),
        ("Quilo", 10.0)
    ]
    
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
        acessGraphicView.layer.cornerRadius = 20.0
        rankView.layer.cornerRadius = 20.0
        rangeWordsView.layer.cornerRadius = 20.0
        knowWordsView.layer.cornerRadius = 20.0
        drawGraphic()
        drawRanking()
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func drawRanking() {
        let frame = getFrame(rankView)
        let axisX = frame.width - 40
        let axisY = frame.height - 70
        let minX = frame.maxX / 2 - frame.width / 2
        let minY = frame.maxY / 2 - frame.height / 2 + 30
        
        let settings = configureGraphic()
    
        let labelSettings = configureLabelLines()
        
        let lines = GuidelinesConfig(dotted: false, lineWidth: 0.0, lineColor: UIColor.bronwLetters)
        
        let chartConfig = BarsChartConfig(
            chartSettings: settings,
            valsAxisConfig: ChartAxisConfig(from: 0, to: 50, by: 10),
            xAxisLabelSettings:labelSettings ,
            yAxisLabelSettings: labelSettings,
            guidelinesConfig: lines)
        
        let chart = BarsChart(
            frame: CGRect(x: minX, y:minY, width: axisX , height: axisY),
            chartConfig: chartConfig,
            xTitle: "",
            yTitle: "",
            bars: self.rank,
            color: UIColor.purpleLetters,
            barWidth: self.rankView.bounds.width/7 - 15
        )
        self.rankView.addSubview(chart.view)
        self.rankChartView = chart
    }
    
    func drawGraphic() {
        let frame = getFrame(acessGraphicView)
        let axisX = frame.width - 40
        let axisY = frame.height - 70
        let minX = frame.maxX / 2 - frame.width / 2
        let minY = frame.maxY / 2 - frame.height / 2 + 30
        
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
            xTitle: "",
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
        settings.axisTitleLabelsToLabelsSpacing = 2
        settings.axisStrokeWidth = 0.2
        settings.spacingBetweenAxesX = 8
        settings.spacingBetweenAxesY = 8
        settings.labelsSpacing = 8
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
    
    func getFrame(_ view: UIView) -> CGRect {
        return view.bounds
    }
    
}
