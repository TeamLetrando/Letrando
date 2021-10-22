//
//  Letter.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 22/10/21.
//

import Foundation
import SceneKit

class Letter: SCNReferenceNode {
    
    init?(name: String) {
        guard let usdzURL: URL = Bundle.main.url(forResource: name, withExtension: "usdz") else { return nil }
        super.init(url: usdzURL)
        self.load()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
