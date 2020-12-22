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
    @IBOutlet weak var messageLabel: UILabel!
    var letters: [String] = []
    var imageViewLetters: [UIImageView] = []
    var word: Word?
    @IBOutlet weak var sceneView: ARSCNView!
    var stack: UIStackView!
    var sceneController = Scene()
    var lettersAdded: Bool = false
    var planes = [Plane]()
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
        }

        word = JsonData().randomWord()
        letters = word?.breakInLetters() ?? []

        makeImage(letters: letters)

        stack.isHidden = true
        messageLabel.isHidden = true
        feedbackGenerator.prepare()
        setupCoachingOverlay()
        setupMessageLabel()
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
    
    func setupMessageLabel() {
        messageLabel.text = "Procure um local mais espaçoso"
        messageLabel.textColor = .whiteViews
        messageLabel.font = UIFont(name: "BubblegumSans-Regular", size: 40)
        messageLabel.backgroundColor = .purpleLetters
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
