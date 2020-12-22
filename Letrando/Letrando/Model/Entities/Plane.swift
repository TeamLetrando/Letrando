//
//  Plane.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 25/11/20.
//

import Foundation
import SceneKit
import ARKit
class Plane: SCNNode {

    var planeAnchor: ARPlaneAnchor

    var planeGeometry: SCNPlane
    var planeNode: SCNNode
    var shadowPlaneGeometry: SCNPlane
    var shadowNode: SCNNode

    init(_ anchor: ARPlaneAnchor) {

        self.planeAnchor = anchor

        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.transparentLightBlue
        self.planeGeometry.materials = [material]
        self.planeGeometry.firstMaterial?.transparency = 0.5
        
        self.planeNode = SCNNode(geometry: planeGeometry)
        self.planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2), 1.0, 0.0, 0.0)
        self.planeNode.castsShadow = false
        self.planeNode.physicsBody = SCNPhysicsBody(type: .static,
                                                    shape: SCNPhysicsShape(geometry: self.planeGeometry,
                                                                           options: nil))
        self.planeNode.physicsBody?.categoryBitMask = BodyType.plane.rawValue

        self.shadowPlaneGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let shadowMaterial = SCNMaterial()
        shadowMaterial.diffuse.contents = UIColor.white
        shadowMaterial.lightingModel = .constant
        shadowMaterial.writesToDepthBuffer = true
        shadowMaterial.colorBufferWriteMask = []

        self.shadowPlaneGeometry.materials = [shadowMaterial]

        self.shadowNode = SCNNode(geometry: shadowPlaneGeometry)
        self.shadowNode.transform = planeNode.transform
        self.shadowNode.castsShadow = false

        super.init()

        self.addChildNode(planeNode)
        self.addChildNode(shadowNode)

        self.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(_ anchor: ARPlaneAnchor) {
        self.planeAnchor = anchor

        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)

        self.shadowPlaneGeometry.width = CGFloat(anchor.extent.x)
        self.shadowPlaneGeometry.height = CGFloat(anchor.extent.z)

        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        let planeNode = self.childNodes.first!
        planeNode.physicsBody = SCNPhysicsBody(type: .static,
                                               shape: SCNPhysicsShape(geometry: planeGeometry,
                                                                      options: nil))
            planeNode.physicsBody?.categoryBitMask = BodyType.plane.rawValue
    }

    func setPlaneVisibility(_ visible: Bool) {
        self.planeNode.isHidden = !visible
    }

}
