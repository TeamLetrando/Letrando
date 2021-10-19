//
//  OnboardingViewController.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 22/09/21.
//

import UIKit

protocol OnboardingViewControllerProtocol: UIViewController {
    func setup(onboardingRouter: OnboardingRouterLogic)
}

class OnboardingViewController: UIPageViewController, ViewCodable, OnboardingViewControllerProtocol {
  
    private lazy var pages = [UIViewController]()
    private lazy var currentIndexPage: Int = .zero
    private var onboardingRouter: OnboardingRouterLogic?
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .greenActionLetrando
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private lazy var nextButton: RoundedButton = {
        let imageButton = UIImage(systemName: SystemIcons.nextButtonIcon.rawValue)
        let nextButton = RoundedButton(backgroundImage: imageButton,
                                       buttonAction: nextButtonAction,
                                       tintColor: .greenActionLetrando)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
    }()

    private lazy var previewButton: RoundedButton = {
        let imageButton = UIImage(systemName: SystemIcons.previewButtonIcon.rawValue)
        let previewButton = RoundedButton(backgroundImage: imageButton,
                                       buttonAction: previewButtonAction,
                                       tintColor: .greenActionLetrando)
        previewButton.isHidden = true
        previewButton.translatesAutoresizingMaskIntoConstraints = false
        return previewButton
    }()
    
    private lazy var dismissButton: RoundedButton = {
        let buttonImage = UIImage(systemName: SystemIcons.exitButtonIcon.rawValue)
        let button = RoundedButton(backgroundImage: buttonImage,
                                   buttonAction: dismissAction,
                                   tintColor: .greenActionLetrando)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        setupView()
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(onboardingRouter: OnboardingRouterLogic) {
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
        let presentationView = PageView(animationName: JsonAnimations.firstOnboardingAnimation.rawValue,
                                       message: LocalizableBundle.firstOnboardingMessage.localize)
        let presentationController = PageViewController()
        presentationController.setup(with: presentationView)
        
        let alertView = PageView(animationName: JsonAnimations.secondOnboardingAnimation.rawValue,
                                        message: LocalizableBundle.secondOnboardingMessage.localize)
        let alertController = PageViewController()
        alertController.setup(with: alertView)
        
        let tutorialView = PageView(animationName: JsonAnimations.thirdOnboardingAnimation.rawValue,
                                       message: LocalizableBundle.thirdOnboardingMessage.localize)
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
        if currentIndexPage == (pages.count - 1) {
            onboardingRouter?.dismissOnboarding()
            return
        }
        setCurrentPage(direction: .forward)
    }
    
    private func previewButtonAction() {
        setCurrentPage(direction: .reverse)
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
        SystemIcons.doneButtonIcon.rawValue : SystemIcons.nextButtonIcon.rawValue
        
        let nextButtonImage = UIImage(systemName: imageIcon)
        nextButton.setBackgroundImage(nextButtonImage, for: .normal)
        nextButton.layoutSubviews()
    }
    
    private func dismissAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        updateLayout(viewController)
        return getPage(direction: .reverse)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        updateLayout(viewController)
        return getPage(direction: .forward)
    }
}
