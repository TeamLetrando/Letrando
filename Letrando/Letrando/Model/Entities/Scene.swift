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

            let letterNode = createTextNode(string: letter)
            letterNode.position = scene.rootNode.convertPosition(position, to: parent)
            parent.addChildNode(letterNode)
            textNode.append(letterNode)

    }

    func createTextNode(string: String) -> SCNNode {
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

    func isPointValid (point: CGPoint, array: [CGPoint]) -> Bool {
        var isValidPoint = true
        array.forEach { (localPoint) in
            if localPoint.distance(to: point) < 300 {
                isValidPoint = false
            }
        }
        return isValidPoint
    }

    func generateRandomPoint() -> CGPoint {
        return CGPoint(x: CGFloat.random(in: -1000...1000), y: CGFloat.random(in: -1000...1000))
    }

}
