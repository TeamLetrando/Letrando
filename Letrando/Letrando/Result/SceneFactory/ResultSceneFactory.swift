//
//  ResultSceneFactory.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 04/10/21.
//

import Foundation

protocol ResultFactory {
    func instantiateResultViewController() -> ResultViewControllerProtocol
    func instantiateResultView(wordResult: String) -> ResultViewProtocol
}

class ResultSceneFactory: ResultFactory {
    func instantiateResultViewController() -> ResultViewControllerProtocol {
        return ResultViewController()
    }
    
    func instantiateResultView(wordResult: String) -> ResultViewProtocol {
        return ResultView(wordResult: wordResult)
    }
}
