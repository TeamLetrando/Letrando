//
//  OnboardingViewController.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 22/09/21.
//

import UIKit
import SoundsKit

protocol OnboardingViewControllerProtocol: UIViewController {
    func setup(onboardingRouter: OnboardingRouterLogic?)
}

class OnboardingViewController: UIPageViewController, ViewCodable, OnboardingViewControllerProtocol {
    
    private lazy var pages = [UIViewController]()
    private lazy var currentIndexPage: Int = .zero
    private weak var onboardingRouter: OnboardingRouterLogic?
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .greenActionLetrando
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private lazy var nextButton: RoundedButton = {
        let imageButton = UIImage(systemName: SystemIcons.arrowRight.rawValue)
        let nextButton = RoundedButton(backgroundImage: imageButton,
                                       buttonAction: nextButtonAction,
                                       tintColor: .greenActionLetrando)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
    }()
    
    private lazy var previewButton: RoundedButton = {
        let imageButton = UIImage(systemName: SystemIcons.arrowBackward.rawValue)
        let previewButton = RoundedButton(backgroundImage: imageButton,
                                          buttonAction: previewButtonAction,
                                          tintColor: .greenActionLetrando)
        previewButton.isHidden = true
        previewButton.translatesAutoresizingMaskIntoConstraints = false
        return previewButton
    }()
    
    private lazy var dismissButton: RoundedButton = {
        let buttonImage = UIImage(systemName: SystemIcons.closeXmark.rawValue)
        let button = RoundedButton(backgroundImage: buttonImage,
                                   buttonAction: dismissAction,
                                   tintColor: .greenActionLetrando)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        try? SoundsKit.playOnboardingLetrando(at: pageControl.currentPage)
        setOrientation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setOrientation()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private func setOrientation() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.myOrientation = .portrait
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(onboardingRouter: OnboardingRouterLogic?) {
        self.onboardingRouter = onboardingRouter
    }
    
    func buildViewHierarchy() {
        view.addSubview(dismissButton)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(previewButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1),
            
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            dismissButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            nextButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            
            previewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            previewButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            previewButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            previewButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13)
        ])
    }
    
    func setupAditionalChanges() {
        configurePages()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentIndexPage
        setViewControllers([pages[currentIndexPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func configurePages() {
        let presentationView = PageView(animationName: JsonAnimations.onboardingPresentation.rawValue,
                                        message: LocalizableBundle.onboardingMessagePresentation.localize)
        let presentationController = PageViewController()
        presentationController.setup(with: presentationView)
        
        let alertView = PageView(animationName: JsonAnimations.onboardingAlert.rawValue,
                                 message: LocalizableBundle.onboardingMessageAlert.localize)
        let alertController = PageViewController()
        alertController.setup(with: alertView)
        
        let tutorialView = PageView(animationName: JsonAnimations.onboardingTablet.rawValue,
                                    message: LocalizableBundle.onboardingMessageInstruction.localize)
        let tutorialController = PageViewController()
        tutorialController.setup(with: tutorialView)
        
        pages.append(presentationController)
        pages.append(alertController)
        pages.append(tutorialController)
    }
    
    fileprivate func getPage(direction: NavigationDirection) -> UIViewController? {
        var page: UIViewController?
        
        switch direction {
        case .forward:
            page = currentIndexPage < (pages.count - 1) ? pages[currentIndexPage + 1] : nil
        case .reverse:
            page = currentIndexPage == .zero ? nil : pages[currentIndexPage - 1]
        @unknown default:
            break
        }
        
        return page
    }
    
    private func nextButtonAction() {
        if currentIndexPage == (pages.count - 1) && SoundsKit.isFinishOnboarding() {
            onboardingRouter?.dismissOnboarding()
            return
        }
        setCurrentPage(direction: .forward)
        try? SoundsKit.playOnboardingLetrando(at: currentIndexPage)
    }
    
    private func previewButtonAction() {
        setCurrentPage(direction: .reverse)
        try? SoundsKit.playOnboardingLetrando(at: currentIndexPage)
    }
    
    private func setCurrentPage(direction: NavigationDirection) {
        let newPage = getPage(direction: direction)
        updateLayout(newPage)
        
        setViewControllers([newPage ?? UIViewController()],
                           direction: direction,
                           animated: true,
                           completion: nil)
    }
    
    private func updateLayout(_ currentViewController: UIViewController?) {
        currentIndexPage = pages.firstIndex(of: currentViewController ?? UIViewController()) ?? .zero
        pageControl.currentPage = currentIndexPage
        
        previewButton.isHidden = currentIndexPage == .zero
        let imageIcon = currentIndexPage == (pages.count - 1) ?
        SystemIcons.arrowTriangle.rawValue : SystemIcons.arrowRight.rawValue
        
        let nextButtonImage = UIImage(systemName: imageIcon)
        nextButton.setBackgroundImage(nextButtonImage, for: .normal)
        nextButton.layoutSubviews()
    }
    
    private func dismissAction() {
        onboardingRouter?.dismissOnboarding()
    }
    
}
