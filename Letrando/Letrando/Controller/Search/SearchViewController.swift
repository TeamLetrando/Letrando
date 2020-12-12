//
//  SearchViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import ARKit
import SceneKit
import AVFoundation

class SearchViewController: UIViewController {
    var letters: [String] = []
    var points: [CGPoint] = []
    var imageViewLetters: [UIImageView] = []
    var word: Word?
    @IBOutlet weak var sceneView: ARSCNView!
    var stack: UIStackView!
    var sceneController = Scene()
    var lettersAdded: Bool = false
    var planeAdded: Bool = false
    var plane: Plane?
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    let coachingOverlay = ARCoachingOverlayView()
    var actualNode: SCNNode = SCNNode()
    var initialPosition = SCNVector3(0, 0, 0)
    @IBOutlet weak var buttonHand: UIButton!
    var score = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        if let scene = sceneController.scene {
            sceneView.scene = scene
            //sceneView.showsStatistics = true
        }

        word = JsonData().randomWord()
        letters = word?.breakInLetters() ?? []

        makeImage(letters: letters)

        stack.isHidden = true

        feedbackGenerator.prepare()
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
    
    func configureUserDefaults() {
        if UserDefaults.standard.object(forKey: "showAnimationFeedback") == nil {
            UserDefaults.standard.setValue(true, forKey: "showAnimationFeedback")
        } else if let isAnimationEnable = UserDefaults.standard.object(forKey: "showAnimationFeedback") as? Bool {
            configureHandImageButton(isAnimationEnable)
        }
    }
    
    @IBAction func showAnimationFeedback(_ sender: Any) {
        if let isAnimationEnable = UserDefaults.standard.object(forKey: "showAnimationFeedback") as? Bool {
            UserDefaults.standard.setValue(!isAnimationEnable, forKey: "showAnimationFeedback")
            configureHandImageButton(!isAnimationEnable)
        }
    }
    
    func configureHandImageButton(_ isAnimationEnable: Bool) {
        if isAnimationEnable {
            buttonHand.setImage(UIImage(named: "handButtonOn"), for: .normal)
        } else {
            buttonHand.setImage(UIImage(named: "handButtonOff"), for: .normal)
        }
    }
    
    func animateFeedBack(initialPosition: CGPoint, letter: String) {
        if let isAnimationEnable = UserDefaults.standard.object(forKey: "showAnimationFeedback") as? Bool,
           isAnimationEnable == false { return }
        stack.subviews.forEach { view in
            if let tappedLetter = view as? UIImageView,
               let letterName = tappedLetter.layer.name,
               letterName == letter {
                let finalPosition = stack.convert(tappedLetter.layer.position, to: sceneView)
                
                let handImage = UIImageView(frame: CGRect(x: initialPosition.x,
                                                          y: initialPosition.y,
                                                          width: 50,
                                                          height: 80))
                handImage.image = UIImage(named: "hand")
                
                sceneView.addSubview(handImage)
                
                UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
                    handImage.layer.position = finalPosition
                } completion: { _ in
                    handImage.removeFromSuperview()
                }
            }
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
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapScreen(gesture: UITapGestureRecognizer) {
            let tapLocation = gesture.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(tapLocation)
            if let node = hitTestResults.first?.node, let name = node.name {
                reproduceSound(string: name.lowercased())
                animateFeedBack(initialPosition: tapLocation,
                                        letter: name)
                
            }
    }
    
    func addMoveGesture() {
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(moveLetterGesture(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }

    @objc func moveLetterGesture(_ gesture: UIPanGestureRecognizer) {
        let tapLocation = gesture.location(in: self.sceneView)
        guard let nodeResult = sceneView.raycastQuery(from: tapLocation,
                                                         allowing: .estimatedPlane,
                                                         alignment: .horizontal) else {return}
        let hitNode = sceneView.hitTest(tapLocation)

        switch gesture.state {

        case .began:
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

        case .changed:
            let newNodeResult = sceneView.session.raycast(nodeResult).last
            if !hitNode.isEmpty {
                guard let newHitResult = newNodeResult else {return}
                actualNode.position = SCNVector3Make(newHitResult.worldTransform.columns.3.x,
                                                     newHitResult.worldTransform.columns.3.y,
                                                     newHitResult.worldTransform.columns.3.z)
            }
            actualNode.scale = SCNVector3(Float(0.02), Float(0.02), Float(0.02))

        case .ended:
            stack.subviews.forEach { (view) in
                if let image = view as? UIImageView {
                    let convertPosition = stack.convert(image.layer.position, to: sceneView)
                    let distance = tapLocation.distance(to: convertPosition)
                    if distance <= 50 {
                        animateView(image)
                        checkAnswer(actualNode, image)
                    } else {
//                        let notification = UINotificationFeedbackGenerator()
//                        notification.notificationOccurred(.error)
                        let action = SCNAction.move(to: initialPosition, duration: 0.5)
                        action.timingMode = .easeInEaseOut
                        actualNode.runAction(action)
                    }
                }
            }

            actualNode.scale = SCNVector3(Float(0.07), Float(0.07), Float(0.07))

        default:
            break
        }
    }

    func checkAnswer(_ object: SCNNode, _ image: UIImageView) {
        guard let name = object.name else {return}
        if name == image.layer.name {
            object.removeFromParentNode()
            image.image = UIImage(named: "lettersFull/\(name)_full")
            image.layer.name = "\(name)_full"
            feedbackGenerator.impactOccurred()
            score+=1
            if score == letters.count, let word = word {
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

    func addWord(letters: [String]) {
        if planeAdded {
            letters.forEach { (letter) in
                var pointInPlane = false
                while !pointInPlane {
                    let tapLocation: CGPoint = .generateRandomPoint()
                    let hitTestResults = sceneView.hitTest(tapLocation)

                    if let node = hitTestResults.first?.node,
                       let plane = node.parent as? Plane,
                       tapLocation.isPointValid(array: points) {
                        pointInPlane = true
                        points.append(tapLocation)
                        if let planeParent = plane.parent, let hitResult = hitTestResults.first {
                            let textPos = SCNVector3Make(
                                hitResult.worldCoordinates.x,
                                hitResult.worldCoordinates.y,
                                hitResult.worldCoordinates.z
                            )
                            sceneController.addLetterToScene(letter: letter, parent: planeParent, position: textPos)
                            self.feedbackGenerator.impactOccurred()
                        }
                    } else {
                        continue
                    }
                }
            }
        }
    }

    @IBAction func backButton(_ sender: UIButton) {
        UserDefaults.standard.setValue(false, forKey: "Launch")
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "home")
                as? HomeViewController else {fatalError()}
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }

    func makeImage(letters: [String]) {
        var imageLetters: [UIImageView] = []
        for oneLetter in letters {
            if let imageLetter = UIImage(named: "lettersEmpty/\(oneLetter).pdf") {
                let image = UIImageView(image: imageLetter)
                image.contentMode = .scaleAspectFill
                image.layer.masksToBounds = true
                image.layer.cornerRadius = 5.0
                image.layer.borderWidth = 1.0
                image.layer.borderColor = UIColor.lightGray.cgColor
                image.clipsToBounds = true
                image.translatesAutoresizingMaskIntoConstraints = false
                image.layer.zPosition = -0.001
                image.layer.name = oneLetter
                imageLetters.append(image)
            }
        }
        setupConstraints(imageLetters: imageLetters)
    }

    func setupConstraints(imageLetters: [UIImageView]) {
        stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 15
        sceneView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalToConstant: 58).isActive = true
        stack.centerXAnchor.constraint(equalTo: sceneView.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        stack.bottomAnchor.constraint(equalTo: sceneView.bottomAnchor, constant: -25).isActive = true
        for ipp in 0...(imageLetters.count - 1) {
            imageLetters[ipp].translatesAutoresizingMaskIntoConstraints = false
            imageLetters[ipp].heightAnchor.constraint(equalTo: imageLetters[ipp].widthAnchor).isActive = true
            stack.addArrangedSubview(imageLetters[ipp])
        }
        imageViewLetters = imageLetters
    }

    func transitionForResultScreen(word: String) {
        let storyboard = UIStoryboard(name: "SearchResult", bundle: nil)
        guard let viewC =  storyboard.instantiateViewController(identifier: "searchResult")
                as? SearchResultViewController else {fatalError()}
        viewC.wordResult = word
        viewC.modalPresentationStyle = .fullScreen
        self.present(viewC, animated: true, completion: nil)
    }
}
