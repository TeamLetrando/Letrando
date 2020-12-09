//
//  Report.swift
//  LetrandoTests
//
//  Created by Ronaldo Gomes on 08/12/20.
//

import XCTest
import CoreData
@testable import Letrando

class ReportTests: XCTestCase {

    func reportsMocks() -> [ReportProtocol] {
        let words = ["Bola", "Bola", "Bola", "Pessoa", "Pessoa", "Jogo", "Escola"]
        let days = [01, 02, 03, 04, 05, 06, 07]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        var reports: [ReportProtocol] = []
        for index in days {
            let someDateTime = formatter.date(from: "2020/10/\(days[index - 1]) 22:31")
            let newReport = ReportMock(word: words[index - 1], date: someDateTime)
            reports.append(newReport)
        }
        return reports
    }

    func test_numberOfLearnedWords_reportsMocks_returnFour() {
        //When
        let reportsMocks = self.reportsMocks()

        //Given
        let sut = Report.numberOfLearnedWords(reports: reportsMocks)

        //Then
        XCTAssertEqual(sut!, 4)
    }

    func test_numberOfLearnedWords_nilReports_returnNil() {
        //Given
        let sut = Report.numberOfLearnedWords(reports: nil)

        //Then
        XCTAssertNil(sut)
    }

    func test_mediaOfWordsInWeek_fourteenWords_returnTwo() {
        //Givem
        let sut = Report.mediaOfWordsInWeek(learnedWords: 14)

        //Then
        XCTAssertEqual(sut, 2)
    }

    func test_mediaOfWordsInWeek_nilWords_returnNil() {
        //Given
        let sut = Report.mediaOfWordsInWeek(learnedWords: nil)

        //Then
        XCTAssertNil(sut)
    }

    func test_getMostSearchWords_reportsMocks_returnsTreeWords() {
        //When
        let reportsMocks = self.reportsMocks()

        //Given
        let sut = Report.getMostSearchWords(reports: reportsMocks)

        //Then
        XCTAssertEqual(sut?.count, 3)
    }

    func test_getMostSearchWords_reportsMocks_returnsBola() {
        //When
        let reportsMocks = self.reportsMocks()

        //Given
        let sut = Report.getMostSearchWords(reports: reportsMocks)

        //Then
        XCTAssertEqual(sut?[0], "Bola")
    }

    func test_getMostSearchWords_nilReports_returnsNil() {
        //Given
        let sut = Report.getMostSearchWords(reports: nil)

        //Then
        XCTAssertNil(sut)
    }

    func test_getMostSearchWords_nilWords_returnsNil() {
        //When
        let report = ReportMock(word: nil, date: nil)

        //Given
        let sut = Report.getMostSearchWords(reports: [report])

        //Then
        XCTAssertNil(sut)
    }

    func test_getWordsADay_reportssMocks_returnsSevenDays() {
        //When
        let report = self.reportsMocks()

        //Given
        let sut = Report.getWordsADay(reports: report)

        //Then
        XCTAssertEqual(sut?.count, 7)
    }

    func test_getWordsADay_nilReports_returnsNil() {
        //Given
        let sut = Report.getWordsADay(reports: nil)

        //Then
        XCTAssertNil(sut)
    }
}
