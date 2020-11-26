//
//  ARModel.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import Foundation
import SceneKit

class ARModel {

    static func createTextNode(string: String) -> SCNNode {
        let text = SCNText(string: string, extrusionDepth: 0.3)
        text.font = UIFont.systemFont(ofSize: 3.0)
        text.flatness = 0.01
        text.firstMaterial?.diffuse.contents = UIColor.white

        let textNode = SCNNode(geometry: text)
        textNode.castsShadow = true

        let fontSize = Float(0.07)
        textNode.scale = SCNVector3(fontSize, fontSize, fontSize)

        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        (minVec, maxVec) =  textNode.boundingBox
        textNode.pivot = SCNMatrix4MakeTranslation(
            minVec.x + (maxVec.x - minVec.x)/2,
            minVec.y,
            minVec.z + (maxVec.z - minVec.z)/2
        )

        return textNode
    }
}
