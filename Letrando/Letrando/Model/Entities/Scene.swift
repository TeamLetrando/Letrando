//
//  Scene.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 25/11/20.
//

import Foundation
import SceneKit
struct Scene {

    var scene: SCNScene?
    var textNode: [SCNNode] = []

    init() {
        scene = self.initializeScene()
    }

    func initializeScene() -> SCNScene? {
        let scene = SCNScene()

        setDefaults(scene: scene)

        return scene
    }

    func setDefaults(scene: SCNScene) {

        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = SCNLight.LightType.ambient
        ambientLightNode.light?.color = UIColor(white: 0.4, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)

        let directionalLight = SCNLight()
        directionalLight.type = .directional
        directionalLight.color = UIColor(white: 0.8, alpha: 1.0)
        directionalLight.shadowRadius = 5.0
        directionalLight.shadowColor = UIColor.black.withAlphaComponent(0.6)
        directionalLight.castsShadow = true
        directionalLight.shadowMode = .deferred
        let directionalNode = SCNNode()
        directionalNode.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-40),
                                                     GLKMathDegreesToRadians(0),
                                                     GLKMathDegreesToRadians(0))
        directionalNode.light = directionalLight
        scene.rootNode.addChildNode(directionalNode)
    }

    mutating func addLetterToScene(letter: String, parent: SCNNode, position: SCNVector3 = SCNVector3Zero) {
        guard let scene = self.scene else { return }

        let letterNode = ARModel.createTextNode(string: letter)
            letterNode.position = scene.rootNode.convertPosition(position, to: parent)
            parent.addChildNode(letterNode)
            textNode.append(letterNode)

    }

}
