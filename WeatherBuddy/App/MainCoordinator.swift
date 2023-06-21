//
//  MainCoordinator.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 14.06.2023.
//

import UIKit

protocol Coordinator {
    func start()
    func presentWeatherPagesScreen(startPage: Int)
    func presentSearchScreen(searchScreenDelegate delegate: SearchViewModelDelegate)
    func dismissModalScreen()
    func dismissCurrentScreen()
}

final class MainCoordinator: Coordinator {
    
    private let builder: Builder
    private let navigationController: UINavigationController
    
    init(builder: Builder, navigationController: UINavigationController) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
    func start() {
        let locationsListVC = builder.locationsListScreen(coordinator: self)
        navigationController.pushViewController(locationsListVC, animated: true)
    }
    
    func presentWeatherPagesScreen(startPage: Int) {
        let pagesScreen = builder.weatherPagesScreen(coordinator: self, startPage: startPage)
        navigationController.pushViewController(pagesScreen, animated: true)
    }
    
    func presentSearchScreen(searchScreenDelegate delegate: SearchViewModelDelegate) {
        let searchVC = builder.searchScreen(coordinator: self, searchScreenDelegate: delegate)
        let searchScreenNav = UINavigationController(rootViewController: searchVC)
        searchScreenNav.modalPresentationStyle = .pageSheet
        navigationController.viewControllers.last?.present(searchScreenNav, animated: true)
    }
    
    func dismissModalScreen() {
        navigationController.viewControllers.last?.dismiss(animated: true)
    }
    
    func dismissCurrentScreen() {
        navigationController.popViewController(animated: true)
    }
    
}
