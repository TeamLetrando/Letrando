//
//  SearchViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//swiftlint:disable multiple_closures_with_trailing_closure

import UIKit
import ARKit
import SceneKit
import AVFoundation

enum BodyType: Int {
    case letter = 1
    case  plane = 2
}

class SearchViewController: UIViewController {
    var word: Word?
    var sceneController = Scene()
    var lettersAdded: Bool = false
    var planes = [Plane]()
    let coachingOverlay = ARCoachingOverlayView()
    var actualNode: SCNNode = SCNNode()
    var initialPosition = SCNVector3(0, 0, 0)
    var score = 0
    
    var sceneView = ARSCNView()
    
    lazy var gameView = GameView()
    weak var delegate: GameViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalPresentationStyle = .fullScreen
        
        gameView.addSubview(sceneView)
        
        layoutSceneView()
        
        sceneView.delegate = self
        if let scene = sceneController.scene {
            sceneView.scene = scene
        }
        
        gameView.delegate = self
        delegate = gameView

        word = JsonData().randomWord()
        gameView.letters = word?.breakInLetters() ?? []

        setupCoachingOverlay()
        addMoveGesture()
        addTapGesture()
        configureUserDefaults()
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
    
    func configureUserDefaults() {
        if UserDefaults.standard.object(forKey: "showAnimationFeedback") == nil {
            UserDefaults.standard.setValue(true, forKey: "showAnimationFeedback")
        } else if let isAnimationEnable = UserDefaults.standard.object(forKey: "showAnimationFeedback") as? Bool {
            delegate?.setHandButtonImage(for: isAnimationEnable ? "handButtonOn" : "handButtonOff")
        }
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
            image.image = UIImage(named: "lettersFull/\(name)_full")
            image.layer.name = "\(name)_full"
            gameView.feedbackGeneratorImpactOccurred()
            score += 1
            if let word = word, score == word.word.count {
                transitionForResultScreen(word: word.word)
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
        NSLayoutConstraint.activate([
            sceneView.widthAnchor.constraint(equalTo: gameView.widthAnchor),
            sceneView.heightAnchor.constraint(equalTo: gameView.heightAnchor),
            sceneView.centerYAnchor.constraint(equalTo: gameView.centerYAnchor),
            sceneView.centerXAnchor.constraint(equalTo: gameView.centerXAnchor)
        ])
    }

    func transitionForResultScreen(word: String) {
        let controller = SearchResultViewController(wordResult: word)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
}

extension SearchViewController: GameControlerDelegate {
    func backToHome() {
        UserDefaults.standard.setValue(false, forKey: "Launch")
        let homeController = HomeViewController()
        homeController.modalPresentationStyle = .fullScreen
        self.present(homeController, animated: true, completion: nil)
    }
}
