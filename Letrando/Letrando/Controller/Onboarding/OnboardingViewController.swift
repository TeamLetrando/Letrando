//
//  OnboardingViewController.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 22/09/21.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    private lazy var pages = [UIViewController]()
    private lazy var initialPage = 0
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .greenActionLetrando
        pageControl.pageIndicatorTintColor = .systemGray2
        return pageControl
    }()
    
    private lazy var nextButton: RoundedButton = {
        let nextButton = RoundedButton(backgroundImage: <#T##UIImage?#>, buttonAction: <#T##(() -> Void)##(() -> Void)##() -> Void#>, tintColor: <#T##UIColor#>)
        
        return nextButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        config()
        layout()
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config() {
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        let presentationPage = AlertViewController(nameAlertAnimation: LocalizableBundle.alertAnimation.localize,
                                                   textAlertMessage: "Apresentando Lelê")
        let alertPage = AlertViewController(nameAlertAnimation: LocalizableBundle.alertAnimation.localize,
                                            textAlertMessage: LocalizableBundle.alertMessage.localize)
        let tutorialPage = AlertViewController(nameAlertAnimation: LocalizableBundle.alertAnimation.localize,
                                               textAlertMessage: "Mostrando como iniciar o jogo")
        pages.append(presentationPage)
        pages.append(alertPage)
        pages.append(tutorialPage)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
    }
    
    func layout() {
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 1)
        ])
    }
    
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex == 0 {
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return pages.first
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let alertsViewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: alertsViewControllers[0]) else { return }
        pageControl.currentPage = currentIndex
    }
}
