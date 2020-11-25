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
    var imageLetters: [UIImageView] = []
    var word: Word?
    @IBOutlet weak var sceneView: ARSCNView!
    var stack: UIStackView!
    var sceneController = Scene()
    var lettersAdded: Bool = false
    var planeAdded: Bool = false
    var plane: Plane?
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    let coachingOverlay = ARCoachingOverlayView()

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

        feedbackGenerator.prepare()
        setupCoachingOverlay()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    func configureSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.delegate = self
        sceneView.session.run(configuration)
    }

    func isPointValid (point: CGPoint, array: [CGPoint]) -> Bool {
        var isValidPoint = true
        array.forEach { (localPoint) in
            if localPoint.distance(to: point) < 300 {
                isValidPoint = false
            }
        }
        return isValidPoint
    }

    func generateRandomPoint() -> CGPoint {
        return CGPoint(x: CGFloat.random(in: -1000...1000), y: CGFloat.random(in: -1000...1000))
    }

    func addWord(letters: [String]) {
        if planeAdded {
            var points: [CGPoint] = []
            letters.forEach { (letter) in
                var pointInPlane = false
                while !pointInPlane {
                    let tapLocation = generateRandomPoint()
                    let hitTestResults = sceneView.hitTest(tapLocation)

                    if let node = hitTestResults.first?.node,
                       let plane = node.parent as? Plane,
                       isPointValid(point: tapLocation, array: points) {
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

    func makeImage(letters: [String]) {
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
                image.layer.zPosition = 20
                self.imageLetters.append(image)
            }
        }
        setupConstraints(imageLetters: imageLetters)
    }
    func setupConstraints(imageLetters: [UIImageView]) {
        stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 5
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.heightAnchor.constraint(equalToConstant: 75).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25).isActive = true
        for ipp in 0...(imageLetters.count - 1) {
            imageLetters[ipp].translatesAutoresizingMaskIntoConstraints = false
            imageLetters[ipp].heightAnchor.constraint(equalTo: imageLetters[ipp].widthAnchor).isActive = true
            stack.addArrangedSubview(imageLetters[ipp])
        }
    }
}
