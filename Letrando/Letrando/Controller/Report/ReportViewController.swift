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
    
    var rankChartView: BarsChart!
    var rank: [(String, Double)]? = [("", 0.0)]
    
    var chartView: BarsChart!
    var bar: [(String, Double)]? = [("", 0.0)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRank()
        getBar()
        drawGraphic()
        drawRanking()
        
        knowWords.text = "\(Report.numberOfLearnedWords()!)"
        rangeWords.text = "\(Report.mediaOfWordsInWeek()!)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRank()
        getBar()
        knowWords.text = "\(Report.numberOfLearnedWords()!)"
        rangeWords.text = "\(Report.mediaOfWordsInWeek()!)"
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func drawRanking() {
        let frame = getFrame(rankView)
        let axisX = frame.width
        let axisY = frame.height
        let minX = frame.minX
        let minY = frame.minY
        
        let settings = configureGraphic()
        
        let labelSettings = configureLabelLines()
        
        let lines = GuidelinesConfig(dotted: false, lineWidth: 0.0, lineColor: UIColor.bronwLetters)
        
        let chartConfig = BarsChartConfig(
            chartSettings: settings,
            valsAxisConfig: ChartAxisConfig(from: 0, to: 50, by: 10),
            xAxisLabelSettings:labelSettings ,
            guidelinesConfig: lines)
        
        let chart = BarsChart(
            frame: CGRect(x: minX, y:minY, width: axisX , height: axisY),
            chartConfig: chartConfig,
            xTitle: "",
            yTitle: "",
            bars: self.rank ?? [("", 0.0)],
            color: UIColor.purpleLetters,
            barWidth: self.rankView.bounds.width/7 - 15
        )
        self.rankView.addSubview(chart.view)
        self.rankChartView = chart
    }
    
    func drawGraphic() {
        let frame = getFrame(acessGraphicView)
        let axisX = frame.width
        let axisY = frame.height
        let minX = frame.minX
        let minY = frame.minY
        
        let settings = configureGraphic()
        
        let labelSettings = configureLabelLines()
        
        let lines = GuidelinesConfig(dotted: false, lineWidth: 0.2, lineColor: UIColor.bronwLetters)
        
        let chartConfig = BarsChartConfig(
            chartSettings: settings,
            valsAxisConfig: ChartAxisConfig(from: 0, to: 100, by: 20),
            xAxisLabelSettings: labelSettings,
            yAxisLabelSettings: labelSettings,
            guidelinesConfig: lines)
        
        let chart = BarsChart(
            frame: CGRect(x: minX, y:minY, width: axisX , height: axisY),
            chartConfig: chartConfig,
            xTitle: "Dias da Semana",
            yTitle: "Total de palavras",
            bars: self.bar ?? [("", 0.0)],
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
    
    func getFrame(_ view: UIView) -> CGRect {
        return view.bounds
    }
    
    func getRank() {
        guard let report = Report.getMostSearchWords() else {
            rank = [("",0.0)]
            return
        }
        
        let size = [40.0, 30.0, 10.0]
        for index in 0...2 {
            rank?.append((report[index], size[index]))
        }
    }
    
    func getBar() {
        guard let workADay = Report.getWordsADay(), let learnedWords = Report.numberOfLearnedWords() else {
            bar = [("", 0.0)]
            return
        }
        
        let weekDays = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"]
        
        for index in 1...7 {
            bar?.append((weekDays[index - 1], Double(((workADay[index] ?? 0) * 100) / learnedWords)))
        }
    }
}
