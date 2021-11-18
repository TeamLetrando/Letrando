//
//  SearchViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.

import UIKit
import ARKit
import SceneKit
import AVFoundation

enum BodyType: Int {
    case letter = 1
    case  plane = 2
}

protocol GameViewControllerProtocol: UIViewController {
    init(wordGame: Word?)
    func setup(with view: GameView, gameRouter: GameRouterLogic)
}

class SearchViewController: UIViewController, GameViewControllerProtocol {
    
    var word: Word?
    var sceneController = Scene()
    var lettersAdded: Bool = false
    var planes = [Plane]()
    let coachingOverlay = ARCoachingOverlayView()
    var actualNode: SCNNode = SCNNode()
    var initialPosition = SCNVector3(0, 0, 0)
    var score = 0
    private var stackViewWidth: NSLayoutConstraint?
    
    var sceneView = ARSCNView()
    
    internal var gameView: GameView?
    private var gameRouter: GameRouterLogic?
    weak var delegate: GameViewDelegate?
    
    required convenience init(wordGame: Word?) {
        self.init()
        self.word = wordGame
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
    
    func setup(with view: GameView, gameRouter: GameRouterLogic) {
        self.gameView = view
        self.gameView?.delegate = self
        self.gameRouter = gameRouter
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
    
    override func loadView() {
        self.view = gameView
    }
    
    func reproduceSound(string: String) {
        let utterance =  AVSpeechUtterance(string: string)
        let voice = AVSpeechSynthesisVoice(language: "pt-BR")
        utterance.voice = voice
        let sintetizer = AVSpeechSynthesizer()
        sintetizer.speak(utterance)
    }
    
    func addTapGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.didTapScreen))
        self.sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    func addMoveGesture() {
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(moveLetterGesture(_:)))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    
    func checkAnswer(_ object: SCNNode, _ image: UIImageView) {
        guard let name = object.name else {return}
        if name == image.layer.name {
            object.removeFromParentNode()
            image.image = UIImage(named: String(format: ImageAssets.letterStackFull.rawValue, name))
            image.layer.name = String(format: ImageAssets.letterFullName.rawValue, name)
            gameView?.feedbackGeneratorImpactOccurred()
            score += 1
            if let word = word, score == word.word.count {
                transitionForResultScreen()
            }
        }
    }
    
    func animateView(_ image: UIImageView) {
        let width = image.frame.size.width
        let height = image.frame.size.height
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            image.frame.size = CGSize(width: width*1.4, height: height*1.2)
        }, completion: { _ in
            image.frame.size = CGSize(width: width, height: height)
        })
    }
    
    func configureSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
    }
    
    func addWord(letters: [String], plane: Plane) {
        
        var lettersNode = [SCNNode]()
        letters.forEach { (letter) in
            let node = ARModel.createTextNode(string: String(letter))
            node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            node.physicsBody?.categoryBitMask = BodyType.letter.rawValue
            
            lettersNode.append(node)
            sceneController.addLetterToScene(letterNode: node)
        }
        
        if plane.planeGeometry.width >= 1 {
            
            generatePositionX(width: Float(plane.planeGeometry.width), nodes: lettersNode)
            generatePositionZ(heigth: Float(plane.planeGeometry.height), nodes: lettersNode)
            generatePositionY(plane: plane, nodes: lettersNode)
            
            if !lettersAdded {
                lettersAdded = true
                lettersNode.forEach { node in
                    plane.addChildNode(node)
                }
            }
        }
        
    }
    
    func generatePositionX(width: Float, nodes: [SCNNode]) {
        let inter = 2 * (width / Float(nodes.count + 2))
        var value = -width
        nodes.forEach { node in
            value += inter
            node.position.x = value
        }
    }
    
    func generatePositionY(plane: SCNNode, nodes: [SCNNode]) {
        nodes.forEach { node in
            node.position.y = plane.position.y
        }
    }
    
    func generatePositionZ(heigth: Float, nodes: [SCNNode]) {
        let inter = heigth / Float(nodes.count)
        let value = heigth - inter
        nodes.forEach { node in
            node.position.z = Float.random(in: -value...value)
        }
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
    
    func transitionForResultScreen() {
        gameRouter?.startResult()
    }
}

extension SearchViewController: GameControlerDelegate {
    func backToHome() {
        gameRouter?.backToHome()
    }
}
