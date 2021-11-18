//
//  SearchViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.

import UIKit
import ARKit
import SceneKit
import AVFoundation

protocol GameViewControllerProtocol: UIViewController {
    init(wordGame: Word?)
    func setup(with view: GameView, gameRouter: GameRouterLogic)
}

class SearchViewController: UIViewController, GameViewControllerProtocol {

    // MARK: - Public Constants
    
    let minScale = SCNVector3(x: 0.5, y: 0.5, z: 0.5)
    let maxScale = SCNVector3(x: 0.8, y: 0.8, z: 0.8)
    let coachingOverlay = ARCoachingOverlayView()
    let minDistanceToStack: CGFloat = 50
    let animationDuration = 0.5
    
    // MARK: - Private Constants
    
    private let totalSpace = CGSize(width: 1.5, height: 1.5)
    
    // MARK: - Public Variables
    
    weak var delegate: GameViewDelegate?
    var initialPosition = SCNVector3(0, 0, 0)
    var areLettersAdded: Bool = false
    var areLettersGenerated: Bool = false
    var gameView: GameView?
    var sceneView = ARSCNView()
    var sceneController = Scene()
    var actualNode = SCNNode()
    var word: Word?
   
    // MARK: - Private Variables
    
    private var score: Int = .zero
    private var gameRouter: GameRouterLogic?
    private var session: ARSession {
        return sceneView.session
    }
    
    // MARK: - Initialization
    
    required convenience init(wordGame: Word?) {
        self.init()
        self.word = wordGame
    }
    
    func setup(with view: GameView, gameRouter: GameRouterLogic) {
        self.gameView = view
        self.gameView?.delegate = self
        self.gameRouter = gameRouter
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = gameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        gameView?.addSubview(sceneView)
        layoutSceneView()
        sceneView.delegate = self
        
        if let scene = sceneController.scene {
            sceneView.scene = scene
        }
        
        delegate = gameView
        setupCoachingOverlay()
        addMoveGesture()
        addTapGesture()
        setOrientation()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscape, .portrait]
    }
    
    private func setOrientation() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.myOrientation = [.landscape, .portrait]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSession()
        setOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Public Functions
    
    func animateView(_ image: UIImageView) {
        let width = image.frame.size.width
        let height = image.frame.size.height
        UIView.animate(withDuration: animationDuration, delay: .zero, options: .curveEaseOut, animations: {
            image.frame.size = CGSize(width: width * 1.4, height: height * 1.2)
        }, completion: { _ in
            image.frame.size = CGSize(width: width, height: height)
        })
    }
    
    func generateNodes(letters: [String]?) -> [SCNNode?] {
        var nodes: [SCNNode?] = []
        let spaceX = 2 * (totalSpace.width / CGFloat(letters?.count ?? .zero + 2))
        var positionX = -totalSpace.width
        let positionZ = -Float(totalSpace.height)
        
        letters?.forEach { letter in
            let node = getNodeFromSCN(nodeName: letter)
            nodes.append(node)
            positionX += spaceX
            node.position = SCNVector3Make(Float(positionX), -0.1, Float.random(in: positionZ...(.zero)))
        }
        return nodes
    }
    
    func addNodesToScene(nodes: [SCNNode?]) {
        nodes.forEach { node in
            sceneController.addLetterToScene(letterNode: node ?? SCNNode())
        }
    }
    
    func addNodesToGame(nodes: [SCNNode?], parent: SCNNode) {
        nodes.forEach { node in
            node?.removeFromParentNode()
            parent.addChildNode(node ?? SCNNode())
        }
    }
    
    func checkAnswer(_ object: SCNNode, _ image: UIImageView) {
        guard let name = object.name else {return}
        if name == image.layer.name {
            object.removeFromParentNode()
            image.image = UIImage(named: String(format: ImageAssets.letterStackFull.rawValue, name))
            image.layer.name = String(format: ImageAssets.letterFullName.rawValue, name)
            gameView?.feedbackGeneratorImpactOccurred()
            score += 1
            let index = sceneController.textNode.firstIndex(of: object) ?? .zero
            sceneController.textNode.remove(at: index)
            if let word = word, score == word.word.count {
                transitionForResultScreen()
            }
        }
    }

    // MARK: - Private functions
    
    private func addTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.didTapScreen))
        self.sceneView.addGestureRecognizer(tapRecognizer)
    }

    private func addMoveGesture() {
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(moveLetterGesture(_:)))
        self.sceneView.addGestureRecognizer(tapGesture)
    }

    private func configureSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration,
                              options: [.resetTracking, .removeExistingAnchors])
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
    }

    private func layoutSceneView() {
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let gameView = gameView else {
            return
        }
        
        NSLayoutConstraint.activate([
            sceneView.widthAnchor.constraint(equalTo: gameView.widthAnchor),
            sceneView.heightAnchor.constraint(equalTo: gameView.heightAnchor),
            sceneView.centerYAnchor.constraint(equalTo: gameView.centerYAnchor),
            sceneView.centerXAnchor.constraint(equalTo: gameView.centerXAnchor)
        ])
    }

    private func transitionForResultScreen() {
        gameRouter?.startResult()
    }
    
    private func getNodeFromSCN(nodeName: String) -> SCNNode {
        guard let scene = SCNScene(named: "art.scnassets/\(nodeName).scn"),
                let node = scene.rootNode.childNode(withName: nodeName, recursively: false) else { return SCNNode() }
        node.scale = SCNVector3(Float(0.02), Float(0.02), Float(0.02))
        node.position = SCNVector3Make(.zero, -0.1, .zero)

        let boxNode = createBoxNode()
        boxNode.castsShadow = true
        boxNode.addChildNode(node)
        boxNode.name = nodeName
        return boxNode
    }
    
    private func createBoxNode() -> SCNNode {
        let box = SCNBox(width: 0.2, height: 0.3, length: 0.2, chamferRadius: .zero)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        box.materials = [material]
    
        return SCNNode(geometry: box)
    }
}

extension SearchViewController: GameControlerDelegate {
    func backToHome() {
        gameRouter?.backToHome()
    }
}
