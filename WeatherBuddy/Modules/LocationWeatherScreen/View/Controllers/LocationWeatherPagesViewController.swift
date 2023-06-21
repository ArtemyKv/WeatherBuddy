//
//  LocationWeatherPagesViewController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 05.10.2022.
//

import UIKit

final class LocationWeatherPagesViewController: UIPageViewController {
    
    var startPage: Int?
    var viewModel: LocationWeatherPagesViewModel!
    var locationWeatherViewControllers: [LocationWeatherViewController] = []
    
    private let pageControl = UIPageControl()
    private let listButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageController()
        configureListButton()
        setupSubviews()
        setupPages()
        setupPageControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupPageController() {
        delegate = self
        dataSource = self
    }
    
    private func configureListButton() {
        let symbolConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
        let image = UIImage(systemName: "list.bullet", withConfiguration: symbolConfig)
        listButton.setImage(image, for: .normal)
        listButton.imageView?.tintColor = .systemRed
        listButton.addTarget(self, action: #selector(listButtonTapped), for: .touchUpInside)
    }
    
    @objc private func listButtonTapped() {
        viewModel.listButtonTapped()
    }
    
    private func setupSubviews() {
        self.view.addSubview(pageControl)
        self.view.addSubview(listButton)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        listButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            pageControl.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            pageControl.heightAnchor.constraint(equalToConstant: 40),
            listButton.trailingAnchor.constraint(equalTo: pageControl.trailingAnchor),
            listButton.topAnchor.constraint(equalTo: pageControl.topAnchor),
            listButton.heightAnchor.constraint(equalTo: pageControl.heightAnchor)
        ])
    }
    
    private func setupPages() {
        viewModel.makeDetailWeatherViewModels()
        guard let currentDetailViewModel = viewModel.currentDetailViewModel else { return }
        let currentLocationVC = LocationWeatherViewController(viewModel: currentDetailViewModel)
        locationWeatherViewControllers.append(currentLocationVC)
        
        for detailViewModel in viewModel.favoritesDetailWeatherViewModels {
            let viewController = LocationWeatherViewController(viewModel: detailViewModel)
            locationWeatherViewControllers.append(viewController)
        }
        let currentPage = startPage ?? 0
        self.setViewControllers([locationWeatherViewControllers[currentPage]], direction: .forward, animated: true)
    }
    
    private func setupPageControl() {
        pageControl.tintColor = UIColor(rgb: 0x121212)
        pageControl.pageIndicatorTintColor = UIColor(rgb: 0x8E8E8F)
        pageControl.currentPageIndicatorTintColor = UIColor(rgb: 0xFFFFFF)
        pageControl.numberOfPages = locationWeatherViewControllers.count
        pageControl.currentPage = startPage ?? 0
    }
}

extension LocationWeatherPagesViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
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
