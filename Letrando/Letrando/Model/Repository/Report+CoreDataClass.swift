//
//  Report+CoreDataClass.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 07/12/20.
//
//

import Foundation
import CoreData

public class Report: NSManagedObject,ReportProtocol {

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
    
    static func readReports() -> [ReportProtocol]? {
        let request: NSFetchRequest<Report> = fetchRequest()
        guard let report = try? AppDelegate.viewContext.fetch(request) else {
            return nil
        }
        return report
    }
    
    // Testar
    static func numberOfLearnedWords(reports: [ReportProtocol]? = readReports()) -> Int? {
        guard let words = reports?.map({ $0.word }) else {
            return nil
        }
        return Array(Set(words)).count
    }
    
    // Testar
    static func mediaOfWordsInWeek(learnedWords: Int? = numberOfLearnedWords()) -> Int? {
        guard let learnedWords =  learnedWords else {
            return nil
        }
        return learnedWords / 7
    }
    
    // Testar
    static func getMostSearchWords(reports: [ReportProtocol]? = readReports() ) -> [String]? {
         guard let words = reports else {
             return nil
         }
         let listOfWords = words.map({ $0.word })
         let mappedWords = listOfWords.map { ($0, 1) }
         var wordsDictionary = Dictionary(mappedWords, uniquingKeysWith: +)
         var listOfMostWords = [String]()
         
         for _ in 0..<3 {
             let word =  wordsDictionary.max { one, two in one.value < two.value}
            guard let newWord = word?.key else {
                 return nil
             }
             listOfMostWords.append((newWord))
             wordsDictionary.removeValue(forKey: (newWord))
         }
         
         return listOfMostWords
     }
    
    // Testar
    static func getWordsADay(reports: [ReportProtocol]? = readReports()) -> [Int]? {
        var wordsADay = [0, 0, 0, 0, 0, 0, 0]
        guard let allReports = reports else {
            return nil
        }
        allReports.forEach { (report) in
            guard let newReport = report.date else {
                return 
            }
            wordsADay[getDayWeek(date: newReport) - 1] += 1
        }
        return wordsADay
    }
    
    // Testar
    static func getDayWeek(date: Date) -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: date)
        return weekDay
    }
}
