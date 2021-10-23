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
    case plane = 2
}

protocol GameViewControllerProtocol: UIViewController {
    init(wordGame: Word?)
    func setup(with view: GameView, gameRouter: GameRouterLogic)
}

class SearchViewController: UIViewController, GameViewControllerProtocol {

    var word: Word?
    var sceneController = Scene()
    var isPlaneAdded: Bool = false
    let coachingOverlay = ARCoachingOverlayView()
    var actualNode: SCNNode = SCNNode()
    var initialPosition = SCNVector3(0, 0, 0)
    var score = 0
   
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
    }
    
    func setup(with view: GameView, gameRouter: GameRouterLogic) {
        self.gameView = view
        self.gameView?.delegate = self
        self.gameRouter = gameRouter
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSession()
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

    func generatePositions(planeSize: CGSize, nodes: [SCNNode?]) {
        let spaceX = 2 * (planeSize.width / CGFloat(nodes.count + 2))
        var positionX = -planeSize.width
    
        let positionZ = -Float(planeSize.height)
        
        nodes.forEach { node in
            positionX += spaceX
            node?.position.x = Float(positionX)
            node?.position.z = Float.random(in: positionZ...0)
            node?.position.y = .zero
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
