//
//  MainCoordinator.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 14.06.2023.
//

import UIKit

protocol MainCoordinatorProtocol: Coordinator {
    func presentWeatherPagesScreen(startPage: Int)
    func presentSearchScreen()
    func dismissModalScreen()
    func dismissCurrentScreen()
}

final class MainCoordinator: MainCoordinatorProtocol {    
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let builder: Builder
    
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
    
    func presentSearchScreen() {
        let childNavController = UINavigationController()
        let childCoordinator = SearchCoordinator(builder: builder, navigationController: childNavController)
        childCoordinator.parentCoordinator = self
        children.append(childCoordinator)
        
        childCoordinator.start()
    }
    
    func dismissModalScreen() {
        navigationController.viewControllers.last?.dismiss(animated: true)
    }
    
    func dismissCurrentScreen() {
        navigationController.popViewController(animated: true)
    }
    
}
