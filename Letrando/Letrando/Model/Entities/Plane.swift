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
    
    private var planeAnchor: ARPlaneAnchor
    private var planeGeometry: SCNPlane?
    private var planeNode: SCNNode?
    private var shadowPlaneGeometry: SCNPlane?
    private var shadowNode: SCNNode?
    lazy var width: CGFloat = planeGeometry?.width ?? .zero
    lazy var height: CGFloat = planeGeometry?.height ?? .zero
    
    init(_ anchor: ARPlaneAnchor) {
        planeAnchor = anchor
        super.init()
        
        setPlaneGeometry(anchor: planeAnchor)
        setPlaneNode(planeGeometry: planeGeometry ?? SCNPlane())
        setShadowPlaneGeometry(anchor: planeAnchor)
        setShadowNode(plane: planeNode ?? SCNNode())
       
        addChildNode(planeNode ?? SCNNode())
        addChildNode(shadowNode ?? SCNNode())
        
        position = SCNVector3(anchor.center.x, .zero, anchor.center.z)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPlaneGeometry(anchor: ARPlaneAnchor) {
        planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.transparentLightBlue
        planeGeometry?.materials = [material]
        planeGeometry?.firstMaterial?.transparency = 0.5
    }
    
    private func setPlaneNode(planeGeometry: SCNPlane) {
        planeNode = SCNNode(geometry: planeGeometry)
        planeNode?.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2), 1.0, 0.0, 0.0)
        planeNode?.castsShadow = false
        planeNode?.physicsBody = SCNPhysicsBody(type: .static,
                                                shape: SCNPhysicsShape(geometry: planeGeometry,
                                                                       options: nil))
        planeNode?.physicsBody?.categoryBitMask = BodyType.plane.rawValue
    }
    
    private func setShadowPlaneGeometry(anchor: ARPlaneAnchor) {
        shadowPlaneGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        let shadowMaterial = SCNMaterial()
        shadowMaterial.diffuse.contents = UIColor.white
        shadowMaterial.lightingModel = .constant
        shadowMaterial.writesToDepthBuffer = true
        shadowMaterial.colorBufferWriteMask = []
        
        shadowPlaneGeometry?.materials = [shadowMaterial]
    }
    
    private func setShadowNode(plane: SCNNode) {
        shadowNode = SCNNode(geometry: shadowPlaneGeometry)
        shadowNode?.transform = plane.transform
        shadowNode?.castsShadow = false
    }
    
}
