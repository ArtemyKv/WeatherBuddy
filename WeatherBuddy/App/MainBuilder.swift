//
//  MainBuilder.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 14.06.2023.
//

import Foundation

protocol Builder {
    func locationsListScreen(coordinator: MainCoordinatorProtocol) -> LocationsListViewController
    func weatherPagesScreen(coordinator: MainCoordinatorProtocol, startPage: Int) -> LocationWeatherPagesViewController
    func searchScreen(coordinator: SearchCoordinatorProtocol) -> SearchTableViewController
    func searchWeatherScreen(location: Location, coordinator: SearchCoordinatorProtocol) -> LocationWeatherViewController
}

final class MainBuilder: Builder {
    
    private let weatherController: WeatherController
    private let geocodingService: GeocodingService
    private let weatherFetchingService: WeatherFetchingService
    
    init(weatherController: WeatherController, geocodingService: GeocodingService, weatherFetchingService: WeatherFetchingService) {
        self.weatherController = weatherController
        self.geocodingService = geocodingService
        self.weatherFetchingService = weatherFetchingService
    }
    
    func locationsListScreen(coordinator: MainCoordinatorProtocol) -> LocationsListViewController {
        let locationsListViewModel = LocationsListViewModel(weatherController: weatherController, coordinator: coordinator)
        let locationsListVC = LocationsListViewController(viewModel: locationsListViewModel)
        return locationsListVC
    }
    
    func weatherPagesScreen(coordinator: MainCoordinatorProtocol, startPage: Int) -> LocationWeatherPagesViewController {
        let pagesViewModel = LocationWeatherPagesViewModel(coordinator: coordinator, weatherController: weatherController)
        let pagesVC = LocationWeatherPagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pagesVC.viewModel = pagesViewModel
        pagesVC.startPage = startPage
        return pagesVC
    }
    
    func searchScreen(coordinator: SearchCoordinatorProtocol) -> SearchTableViewController {
        let searchingService = SearchingService()
        let searchViewModel = SearchViewModel(coordinator: coordinator, searchingService: searchingService, geocodingService: geocodingService)
        searchingService.delegate = searchViewModel
        let searchVC = SearchTableViewController(viewModel: searchViewModel)
        return searchVC
    }
    
    func searchWeatherScreen(location: Location, coordinator: SearchCoordinatorProtocol) -> LocationWeatherViewController {
        let searchWeatherViewModel = SearchWeatherViewModel(weatherFetchingService: weatherFetchingService, location: location, coordinator: coordinator)
        let searchWeatherVC = SearchWeatherViewController(viewModel: searchWeatherViewModel)
        return searchWeatherVC
    }
}
