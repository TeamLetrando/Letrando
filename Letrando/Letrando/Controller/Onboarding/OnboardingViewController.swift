//
//  OnboardingViewController.swift
//  Letrando
//
//  Created by Kellyane Nogueira on 22/09/21.
//

import UIKit

class OnboardingViewController: UIPageViewController, ViewCodable {
 
    private lazy var pages = [UIViewController]()
    private lazy var currentIndexPage: Int = .zero
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .greenActionLetrando
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.isUserInteractionEnabled = false
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
        previewButton.isHidden = true
        previewButton.translatesAutoresizingMaskIntoConstraints = false
        return previewButton
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
    
    func buildViewHierarchy() {
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(previewButton)
    }
    
    func setupConstraints() {
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
    
    func setupAditionalChanges() {
        configurePages()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = currentIndexPage
        setViewControllers([pages[currentIndexPage]], direction: .forward, animated: true, completion: nil)
    }

    func configurePages() {
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
    
    fileprivate func getPage(direction: NavigationDirection) -> UIViewController? {
        var page: UIViewController?
    
        switch direction {
        case .forward:
            page = currentIndexPage < pages.count - 1 ? pages[currentIndexPage + 1] : nil
        case .reverse:
            page = currentIndexPage == .zero ? nil : pages[currentIndexPage - 1]
        @unknown default:
            break
        }
    
        return page
    }
    
    private func nextButtonAction() {
        if currentIndexPage == (pages.count - 1) {
            dismiss(animated: true)
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
        
        previewButton.isHidden = currentIndexPage == .zero ? true : false
        let imageIcon = currentIndexPage == (pages.count - 1) ?
        LocalizableBundle.doneButtonIcon.localize : LocalizableBundle.nextButtonIcon.localize
        
        let nextButtonImage = UIImage(systemName: imageIcon)
        nextButton.setBackgroundImage(nextButtonImage, for: .normal)
        nextButton.layoutSubviews()
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
