//
//  ReportRepository.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import Foundation
import CoreData

class Report: NSManagedObject {

    @discardableResult
    static func createReport(word: String) -> Bool {
        let report = Report(context: AppDelegate.viewContext)
        report.word = word
        report.date = NSDate.now
        do {
            try AppDelegate.viewContext.save()
            return true
        } catch {
            return false
        }
    }
    
    static func readReports() -> [Report]? {
        let request: NSFetchRequest<Report> = fetchRequest()
        guard let report = try? AppDelegate.viewContext.fetch(request) else {
            return nil
        }
        return report
    }
    
    static func numberOfLearnedWords() -> Int? {
        guard let words = readReports()?.map({ $0.word }) else {
            return nil
        }
        return Array(Set(words)).count
        
    }
    
    static func mediaOfWordsInWeek() -> Int? {
        guard let learnedWords = numberOfLearnedWords() else {
            return nil
        }
        return learnedWords / 7
    }
    
    static func getMostSearchWords() -> [String]? {
        guard let words = readReports() else {
            return nil
        }
        let listOfWords = words.map({ $0.word })
        let mappedWords = listOfWords.map { ($0, 1) }
        var wordsDictionary = Dictionary(mappedWords, uniquingKeysWith: +)
        var listOfMostWords = [String]()
        
        for _ in 0..<3 {
            let word =  wordsDictionary.max { one, two in one.value < two.value}
            guard let newWord = word else {
                return nil
            }
            listOfMostWords.append((newWord.key)!)
            wordsDictionary.removeValue(forKey: (newWord.key)!)
        }
        
        return listOfMostWords
    }
    
    static func getWordsADay() -> [Int: Int]? {
        var wordsADay = [1: 0, 2:0, 3:0, 4:0, 5:0, 6:0, 7:0]
        let allReports = readReports()
        guard let reports = allReports else {
            return nil
        }
        reports.forEach { (report) in
            guard let newReport = report.date else {
                return
            }
            wordsADay[getDayWeek(date: newReport)]! += 1
        }
        return wordsADay
    }
    
    static func getDayWeek(date: Date) -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        return weekDay
    }
}
