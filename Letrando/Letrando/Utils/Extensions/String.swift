//
//  String.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 14/09/21.
//

import Foundation

extension String {
    
    func localize(_ acessibility: Bool = false, bundle: Bundle) -> String {
        return NSLocalizedString(self, tableName: acessibility ? "AccessibilityLocalizable" : "Localizable",
                                 bundle: bundle, value: "", comment: "")
    }
}
