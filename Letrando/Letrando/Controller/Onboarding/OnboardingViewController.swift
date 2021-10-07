//
//  OnboardingViewController.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 22/09/21.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    private lazy var pages = [UIViewController]()
    private lazy var initialPage: Int = .zero
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .greenActionLetrando
        pageControl.pageIndicatorTintColor = .systemGray2
        return pageControl
    }()
    
    private lazy var nextButton: RoundedButton = {
        let imageButton = UIImage(systemName: LocalizableBundle.nextButtonIcon.localize)
        let nextButton = RoundedButton(backgroundImage: imageButton,
                                       buttonAction: nextButtonAction,
                                       tintColor: .greenActionLetrando)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        return nextButton
    }()

    private lazy var previewButton: RoundedButton = {
        let imageButton = UIImage(systemName: LocalizableBundle.previewButtonIcon.localize)
        let previewButton = RoundedButton(backgroundImage: imageButton,
                                       buttonAction: previewButtonAction,
                                       tintColor: .greenActionLetrando)
        previewButton.translatesAutoresizingMaskIntoConstraints = false
        return previewButton
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        configure()
        setLayout()
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        addPages()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func setLayout() {
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(previewButton)
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1),
            
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
    
    func addPages() {
        let firstAnimation = LocalizableBundle.firstOnboardingAnimation.localize
        let firstMessage = LocalizableBundle.firstOnboardingMessage.localize
        let presentationPage = AlertViewController(nameAlertAnimation: firstAnimation, textAlertMessage: firstMessage)
        
        let secondAnimation = LocalizableBundle.secondOnboardingAnimation.localize
        let secondMessage = LocalizableBundle.secondOnboardingMessage.localize
        let alertPage = AlertViewController(nameAlertAnimation: secondAnimation, textAlertMessage: secondMessage)
        
        let thirdAnimation = LocalizableBundle.thirdOnboardingAnimation.localize
        let thirdMessage = LocalizableBundle.thirdOnboardingMessage.localize
        let tutorialPage = AlertViewController(nameAlertAnimation: thirdAnimation, textAlertMessage: thirdMessage)
        
        pages.append(presentationPage)
        pages.append(alertPage)
        pages.append(tutorialPage)
    }
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func getPage(direction: NavigationDirection,
                             currentViewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: currentViewController) else { return nil }
        var page: UIViewController?
    
        switch direction {
        case .forward:
            page = currentIndex < pages.count - 1 ? pages[currentIndex + 1] : pages.first
        case .reverse:
            page = currentIndex == .zero ? pages.last : pages[currentIndex - 1]
        @unknown default:
            break
        }
        
        return page
    }
    
    private func nextButtonAction() {
        setCurrentPage(direction: .forward)
    }
    
    private func previewButtonAction() {
        setCurrentPage(direction: .reverse)
    }
    
    private func setCurrentPage(direction: NavigationDirection) {
        let currentPage = pages[pageControl.currentPage]
        let newCurrentPage = getPage(direction: direction, currentViewController: currentPage)
        let currentIndex = pages.firstIndex(of: newCurrentPage ?? UIViewController())
        pageControl.currentPage = currentIndex ?? .zero
        setViewControllers([newCurrentPage ?? UIViewController()],
                           direction: direction,
                           animated: true,
                           completion: nil)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPage(direction: .reverse, currentViewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getPage(direction: .forward, currentViewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let alertViewController = pageViewController.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: alertViewController) else { return }
        pageControl.currentPage = currentIndex
    }
}
