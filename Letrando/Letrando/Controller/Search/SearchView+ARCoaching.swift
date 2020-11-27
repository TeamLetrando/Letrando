//
//  SearchView+ARCoaching.swift
//  Letrando
//
//  Created by Lidiane Gomes Barbosa on 25/11/20.
//

import Foundation
import SceneKit
import ARKit
@available(iOS 13.0, *)
extension SearchViewController: ARCoachingOverlayViewDelegate {
    
//    /// - Tag: HideUI
//    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        upperControlsView.isHidden = true
//    }
//
//    /// - Tag: PresentUI
//    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        upperControlsView.isHidden = false
//    }
//
//    /// - Tag: StartOver
//    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
//        restartExperience()
//    }

    func setupCoachingOverlay() {
        // Set up coaching view
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self

        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(coachingOverlay)

        NSLayoutConstraint.activate([
            coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])

        setActivatesAutomatically()

        // Most of the virtual objects in this sample require a horizontal surface,
        // therefore coach the user to find a horizontal plane.
        setGoal()
    }

    /// - Tag: CoachingActivatesAutomatically
    func setActivatesAutomatically() {
        coachingOverlay.activatesAutomatically = true
    }

    /// - Tag: CoachingGoal
    func setGoal() {
        coachingOverlay.goal = .horizontalPlane
    }
}
