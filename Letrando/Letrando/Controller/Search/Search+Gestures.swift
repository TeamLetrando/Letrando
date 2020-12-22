//
//  Search+Gestures.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 21/12/20.
//

import Foundation
import UIKit
import ARKit
import SceneKit

extension SearchViewController {
    @objc func moveLetterGesture(_ gesture: UIPanGestureRecognizer) {
        let tapLocation = gesture.location(in: self.sceneView)
        guard let nodeResult = sceneView.raycastQuery(from: tapLocation,
                                                      allowing: .existingPlaneGeometry,
                                                         alignment: .horizontal) else {return}
//        let hitNode = sceneView.hitTest(tapLocation)
    //    let tapLocation = gesture.location(in: sceneView)
    //    let hitNode = sceneView.hitTest(tapLocation)
        
         let hitNode = sceneView.hitTest(tapLocation)

        switch gesture.state {

        case .began:
            beganState(hitNode: hitNode, nodeResult: nodeResult, tapLocation: tapLocation)
        case .changed:
          changedState(hitNode: hitNode, nodeResult: nodeResult)

        case .ended:
            endedState(tapLocation: tapLocation)
        default:
            break
        }
    }
    
    func beganState(hitNode: [SCNHitTestResult], nodeResult: ARRaycastQuery, tapLocation: CGPoint) {
        initialPosition = SCNVector3(nodeResult.direction.x, nodeResult.direction.y, nodeResult.direction.z)
        sceneController.textNode.forEach { (node) in
            if node == hitNode.first?.node {
                node.position = SCNVector3Make(nodeResult.direction.x,
                                               nodeResult.direction.y,
                                               nodeResult.direction.z)
                actualNode = node
                sceneView.scene.rootNode.addChildNode(actualNode)
                if let name = node.name {
                    animateFeedBack(initialPosition: tapLocation,
                                        letter: name)
                    reproduceSound(string: name.lowercased())
                    
                }
            }
        }

    }
    
    func changedState(hitNode: [SCNHitTestResult], nodeResult: ARRaycastQuery) {
        let newNodeResult = sceneView.session.raycast(nodeResult).last
        if !hitNode.isEmpty {
            guard let newHitResult = newNodeResult else {return}
            actualNode.position = SCNVector3Make(newHitResult.worldTransform.columns.3.x,
                                                 newHitResult.worldTransform.columns.3.y,
                                                 newHitResult.worldTransform.columns.3.z)
        }
        actualNode.scale = SCNVector3(Float(0.02), Float(0.02), Float(0.02))
    }
    
    func endedState(tapLocation: CGPoint) {
        stack.subviews.forEach { (view) in
            if let image = view as? UIImageView {
                let convertPosition = stack.convert(image.layer.position, to: sceneView)
                let distance = tapLocation.distance(to: convertPosition)
                if distance <= 50 {
                    animateView(image)
                    checkAnswer(actualNode, image)
                } else {
                    let action = SCNAction.move(to: initialPosition, duration: 0.5)
                    action.timingMode = .easeInEaseOut
                    actualNode.runAction(action)
                }
            }
        }

        actualNode.scale = SCNVector3(Float(0.07), Float(0.07), Float(0.07))

    }
    
    @objc func didTapScreen(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(tapLocation)
        
        if let hitResult = hitTestResult.first, let name = hitResult.node.name {
            reproduceSound(string: name.lowercased())
            animateFeedBack(initialPosition: tapLocation,
                            letter: name)
            
        }
    }
}
