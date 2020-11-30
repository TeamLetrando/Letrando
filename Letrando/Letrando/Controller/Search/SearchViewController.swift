//
//  SearchViewController.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
//

import UIKit
import ARKit
import SceneKit

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
    var resultLetters: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        if let scene = sceneController.scene {
            sceneView.scene = scene
            //sceneView.showsStatistics = true
        }

        word = JsonData().randomWord()
        letters = word?.breakInLetters() ?? []

        let imageViewLetters = makeImage(letters: letters)
        getNodeView(imageViewLetters)
        stack.isHidden = true

        feedbackGenerator.prepare()
        setupCoachingOverlay()

        addMoveGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
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
            //print(actualNode.position.z)

        case .ended:
            let indexImage: Int! = Int(stack.restorationIdentifier!)
            //frame.intersection
            //stack.contains(actualNode)
            //answer.frame.contains(image.center)
            
            if actualNode.contains(stack) {
                checkAnswer(actualNode, initialPosition)
            }
            actualNode.scale = SCNVector3(Float(0.07), Float(0.07), Float(0.07))

        default:
            break
        }
    }

    func checkAnswer(_ object: SCNNode, _ location: SCNVector3) {
        let indexImage: Int! = Int(stack.restorationIdentifier!)
        if object.name == stack.layer.name {
            object.removeFromParentNode()

            let newImage = UIImageView()
            newImage.image = UIImage(named: "lettersFull/\(object.name).pdf")
            newImage.contentMode = .scaleAspectFill
            newImage.layer.masksToBounds = true
            newImage.layer.cornerRadius = 5.0
            newImage.layer.borderWidth = 1.0
            newImage.layer.borderColor = UIColor.lightGray.cgColor
            newImage.clipsToBounds = true
            newImage.translatesAutoresizingMaskIntoConstraints = false
            newImage.layer.zPosition = 0
            stack.insertSubview(newImage, at: indexImage)

//            resultLetters.append(object.name!)
//            if resultLetters == letters {
//                //chamar função
//            }
            
            //Criar vetor para add as letras do tipo string a cada interação

        } else {
            let action = SCNAction.move(to: location, duration: 3)
            action.timingMode = .easeInEaseOut
            object.runAction(action)
        }
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeImage(letters: [String]) -> [UIImageView] {
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
                image.layer.zPosition = 0
                image.layer.name = oneLetter
                imageLetters.append(image)
            }
        }
        return setupConstraints(imageLetters: imageLetters)
    }
    
    func setupConstraints(imageLetters: [UIImageView]) -> [UIImageView] {
        stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalToConstant: 58).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        for ipp in 0...(imageLetters.count - 1) {
            imageLetters[ipp].translatesAutoresizingMaskIntoConstraints = false
            imageLetters[ipp].heightAnchor.constraint(equalTo: imageLetters[ipp].widthAnchor).isActive = true
            stack.restorationIdentifier = String(ipp)
            stack.layer.name = imageLetters[ipp].layer.name
            stack.addArrangedSubview(imageLetters[ipp])
        }
        return imageLetters
    }
    func getNodeView(_ imageViewLetters: [UIImageView]) {
        for ipp in 0...(imageViewLetters.count - 1) {
            let plane = SCNPlane(width: 0.1, height: 0.1)
            plane.firstMaterial?.diffuse.contents = imageViewLetters[ipp]
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3(0, 0, 10)
            self.sceneView.scene.rootNode.addChildNode(planeNode)
        }
    }
}
