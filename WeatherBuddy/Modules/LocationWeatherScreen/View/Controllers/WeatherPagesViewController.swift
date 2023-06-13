//
//  WeatherPagesViewController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 05.10.2022.
//

import UIKit

class WeatherPagesViewController: UIPageViewController {
    
    let pageControl = UIPageControl()
    var initialPage: Int?
    
    var locationWeatherViewControllers: [LocationWeatherViewController] = []
    var detailWeatherViewModels: [DetailWeatherViewModel]? {
        didSet {
            setupPages()
            setupPageControl()
        }
    }
    
    let backToListButton: UIButton = {
        let button = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
        let image = UIImage(systemName: "list.bullet", withConfiguration: symbolConfig)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .systemRed
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        delegate = self
        dataSource = self
        backToListButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        setupView()

    }

    func setupPages() {
        guard let detailWeatherViewModels = detailWeatherViewModels else { return }
        for viewModel in detailWeatherViewModels {
            let viewController = LocationWeatherViewController(viewModel: viewModel)
            locationWeatherViewControllers.append(viewController)
        }
        let currentPage = initialPage ?? 0
        self.setViewControllers([locationWeatherViewControllers[currentPage]], direction: .forward, animated: true)
    }
    
    func setupPageControl() {
        pageControl.tintColor = UIColor(rgb: 0x121212)
        pageControl.pageIndicatorTintColor = UIColor(rgb: 0x8E8E8F)
        pageControl.currentPageIndicatorTintColor = UIColor(rgb: 0xFFFFFF)
        pageControl.numberOfPages = locationWeatherViewControllers.count
        pageControl.currentPage = initialPage ?? 0
    }
    
    func setupView() {
        self.view.addSubview(pageControl)
        self.view.addSubview(backToListButton)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        backToListButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pageControl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pageControl.heightAnchor.constraint(equalToConstant: 40),
            backToListButton.trailingAnchor.constraint(equalTo: pageControl.trailingAnchor),
            backToListButton.topAnchor.constraint(equalTo: pageControl.topAnchor),
            backToListButton.heightAnchor.constraint(equalTo: pageControl.heightAnchor)
        ])
    }
    
    @objc func buttonTapped(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension WeatherPagesViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = locationWeatherViewControllers.firstIndex(of: viewController as! LocationWeatherViewController),
              index > 0
        else { return nil }
        
        return locationWeatherViewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = locationWeatherViewControllers.firstIndex(of: viewController as! LocationWeatherViewController),
              index < (locationWeatherViewControllers.count - 1)
        else { return nil }
        
        return locationWeatherViewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentVC = self.viewControllers![0]
        pageControl.currentPage = locationWeatherViewControllers.firstIndex(of: currentVC as! LocationWeatherViewController)!
    }
    
    
}
