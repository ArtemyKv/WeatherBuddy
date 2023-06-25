//
//  SearchWeatherViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 22.06.2023.
//

import Foundation

final class SearchWeatherViewModel: LocationWeatherViewModel {
    static let addLocationToFavoritesNotification = Notification.Name("AddLocationToFavoritesNotification")
    
    let weatherFetchingService: WeatherFetchingService
    weak var coordinator: SearchCoordinatorProtocol!
    
    override var location: Location? {
        didSet {
            guard let location else { return }
            setupLocationViewModel(with: location)
            fetchWeather()
        }
    }
    
    init(weatherFetchingService: WeatherFetchingService, location: Location? = nil, coordinator: SearchCoordinatorProtocol) {
        self.weatherFetchingService = weatherFetchingService
        self.coordinator = coordinator
        super .init(location: location)
        fetchWeather()
    }
    
    private func fetchWeather() {
        fetchCurrentWeather()
        fetchForecast()
    }
    
    private func fetchCurrentWeather() {
        guard let location else { return }
        weatherFetchingService.fetchCurrentWeatherData(for: location) { [weak self] weather, error in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
            
            guard let weather else { return }
            self?.currentWeather = weather
        }
    }
    
    private func fetchForecast() {
        guard let location else { return }
        weatherFetchingService.fetchForecastWeatherData(for: location) { [weak self] forecastResponse, error in
            guard error == nil else {
                print("ERROR: \(error!.localizedDescription)")
                return
            }
            
            guard let forecastResponse else { return }
            self?.weatherForecast = forecastResponse.list
            print("Fetched!")
        }
    }
    
    func addButtonTapped() {
        postAddToFavoritesNotification()
        coordinator.removeSearchScreen()
    }
    
    private func postAddToFavoritesNotification() {
        guard let location else { return }
        NotificationCenter.default.post(name: SearchWeatherViewModel.addLocationToFavoritesNotification, object: nil, userInfo: ["Location": location])
    }
}
