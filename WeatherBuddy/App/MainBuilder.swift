//
//  MainBuilder.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 14.06.2023.
//

import Foundation

protocol Builder {
    func locationsListScreen(coordinator: Coordinator) -> LocationsListViewController
    func weatherPagesScreen(coordinator: Coordinator, startPage: Int) -> WeatherPagesViewController
    func searchScreen(coordinator: Coordinator, searchScreenDelegate delegate: SearchViewModelDelegate) -> SearchTableViewController
}

class MainBuilder: Builder {
    
    let weatherController: WeatherController
    
    init(weatherController: WeatherController) {
        self.weatherController = weatherController
    }
    
    func locationsListScreen(coordinator: Coordinator) -> LocationsListViewController {
        let locationsListViewModel = LocationsListViewModel()
        locationsListViewModel.weatherController = weatherController
        locationsListViewModel.coordinator = coordinator
        let locationsListVC = LocationsListViewController(viewModel: locationsListViewModel)
        return locationsListVC
    }
    
    func weatherPagesScreen(coordinator: Coordinator, startPage: Int) -> WeatherPagesViewController {
        let pagesViewModel = PagesViewModel(coordinator: coordinator, weatherController: weatherController)
        let pagesVC = WeatherPagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pagesVC.viewModel = pagesViewModel
        pagesVC.startPage = startPage
        return pagesVC
    }
    
    func searchScreen(coordinator: Coordinator, searchScreenDelegate delegate: SearchViewModelDelegate) -> SearchTableViewController {
        let searchingService = SearchingService()
        let searchViewModel = SearchViewModel()
        searchViewModel.coordinator = coordinator
        searchViewModel.searchingService = searchingService
        searchViewModel.delegate = delegate
        searchingService.delegate = searchViewModel
        let searchVC = SearchTableViewController(viewModel: searchViewModel)
        return searchVC
    }
    
}
