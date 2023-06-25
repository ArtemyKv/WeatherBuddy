//
//  SearchCoordinator.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 22.06.2023.
//

import Foundation
import UIKit

protocol SearchCoordinatorProtocol: Coordinator {
    func presentSearchWeatherScreen(location: Location)
    func removeSearchScreen()
    func finish()
}

final class SearchCoordinator: SearchCoordinatorProtocol {
    
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let builder: Builder
    
    init(builder: Builder, navigationController: UINavigationController) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
    func start() {
        let searchVC = builder.searchScreen(coordinator: self)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.pushViewController(searchVC, animated: false)
        parentCoordinator?.navigationController.present(navigationController, animated: true)
    }
    
    func presentSearchWeatherScreen(location: Location) {
        let searchWeatherVC = builder.searchWeatherScreen(location: location, coordinator: self)
        navigationController.pushViewController(searchWeatherVC, animated: true)
    }
    
    func removeSearchScreen() {
        let mainCoordinator = parentCoordinator as! MainCoordinator
        finish()
        mainCoordinator.dismissModalScreen()
    }
    
    func finish() {
        parentCoordinator?.childDidFinish(self)
    }
}
