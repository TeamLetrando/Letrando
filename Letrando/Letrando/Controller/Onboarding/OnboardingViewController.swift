//
//  OnboardingViewController.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 22/09/21.
//

import UIKit

private enum PageDirection {
    case next
    case preview
}

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
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1)
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
    
    fileprivate func getPage(direction: PageDirection, currentViewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: currentViewController) else { return nil }
        var page: UIViewController?
        
        switch direction {
        case .next:
            page = currentIndex < pages.count - 1 ? pages[currentIndex + 1] : pages.first
        case .preview:
            page = currentIndex == .zero ? pages.last : pages[currentIndex - 1]
        }
        
        return page
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPage(direction: .preview, currentViewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getPage(direction: .next, currentViewController: viewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let alertViewController = pageViewController.viewControllers?.first,
              let currentIndex = pages.firstIndex(of: alertViewController) else { return }
        pageControl.currentPage = currentIndex
    }
    
}
