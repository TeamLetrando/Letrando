//
//  ReportMock.swift
//  LetrandoTests
//
//  Created by Ronaldo Gomes on 08/12/20.
//

import Foundation
import CoreData
@testable import Letrando

class ReportMock: ReportProtocol {
    var word: String?
    
    var date: Date?
    
    init(word: String?, date: Date?) {
        self.word = word
        self.date = date
    }
}
