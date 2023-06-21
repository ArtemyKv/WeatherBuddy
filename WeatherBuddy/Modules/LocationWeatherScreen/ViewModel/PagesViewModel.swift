//
//  PagesViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 16.06.2023.
//

import Foundation

class PagesViewModel {
    
    let coordinator: Coordinator
    let weatherController: WeatherController
    
    private(set) var currentDetailViewModel: DetailWeatherViewModel?
    private(set) var favoritesDetailWeatherViewModels: [DetailWeatherViewModel] = []
    
    init(coordinator: Coordinator, weatherController: WeatherController) {
        self.coordinator = coordinator
        self.weatherController = weatherController
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCurrentLocationDetailViewModel),
            name: WeatherController.didSetWeatherForCurrentLocationNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFavoriteLocationsDetailViewModels),
            name: WeatherController.didSetWeatherForFavoriteLocationsNotification,
            object: nil
        )
    }
    
    
    @objc private func updateCurrentLocationDetailViewModel() {
        currentDetailViewModel?.currentWeather = weatherController.currentLocationWeather
        currentDetailViewModel?.weatherForecast = weatherController.currentLocationForecast
    }
    
    @objc private func updateFavoriteLocationsDetailViewModels() {
        for i in 0..<weatherController.favoriteLocationsCount() {
            let location = weatherController.favoriteLocation(at: i)!
            favoritesDetailWeatherViewModels[i].currentWeather = weatherController.weatherByLocation[location]
            favoritesDetailWeatherViewModels[i].weatherForecast = weatherController.forecastByLocation[location]
        }
    }
    
    func makeDetailWeatherViewModels() {
        if let currentLocation = weatherController.currentLocation() {
            let currentLocationDetailViewModel = DetailWeatherViewModel(location: currentLocation)
            currentDetailViewModel = currentLocationDetailViewModel
        }
        
        for i in 0..<weatherController.favoriteLocationsCount() {
            let location = weatherController.favoriteLocation(at: i)!
            let favoriteLocationDetailViewModel = DetailWeatherViewModel(location: location)
            favoritesDetailWeatherViewModels.append(favoriteLocationDetailViewModel)
        }
        updateCurrentLocationDetailViewModel()
        updateFavoriteLocationsDetailViewModels()
    }
    
    func listButtonTapped() {
        coordinator.dismissCurrentScreen()
    }
    
}
