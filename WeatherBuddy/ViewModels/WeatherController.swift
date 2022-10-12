//
//  LocationPagesViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 05.10.2022.
//

import Foundation
import CoreData

class WeatherController {
    //MARK: - Service properties
    lazy var coreDataStack = CoreDataStack(modelName: "WeatherBuddy")
    private lazy var geocodingService: GeocodingService = {
        let geocodingService = GeocodingService()
        geocodingService.coreDataStack = coreDataStack
        return geocodingService
    }()
    private let locationService = LocationService()
    private let weatherFetchingService = WeatherFetchingService()
    
    //MARK: - Location properties
    var favoriteLocations: [Location] = []
    var currentLocation: Location? {
        didSet {
            locationsListViewModel.currentLocation = currentLocation
        }
    }
    
    //MARK: - View Models
    var detailWeatherViewModels: [DetailWeatherViewModel] = []
    var locationsListViewModel = LocationsListViewModel()
    
    //MARK: - Init
    init() {
        locationService.delegate = self
    }
    
    //MARK: - Locations fetching method
    private func fetchFavoriteLocations() {
        let fetchRequest = Location.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Location.order), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try coreDataStack.managedContext.fetch(fetchRequest)
            favoriteLocations = results
        } catch let error as NSError {
            print("Unable to fetch \(error), \(error.userInfo)")
        }
    }
    
    private func createDetailWeatherViewModels() {
        guard let currentLocation = currentLocation else { return }
        let currentLocationDetailWeatherViewModel = DetailWeatherViewModel(location: currentLocation)
        detailWeatherViewModels = [currentLocationDetailWeatherViewModel]
        
        guard !favoriteLocations.isEmpty else { return }
        for location in favoriteLocations {
            let detailWeatherViewModel = DetailWeatherViewModel(location: location)
            detailWeatherViewModels.append(detailWeatherViewModel)
        }
    }
    
    //MARK: - Weather Fethcing methods
    private func fetchWeatherForFavoriteLocations() {
        for (i, location) in favoriteLocations.enumerated() {
            let viewModelIndex = i + 1
            weatherFetchingService.fetchCurrentWeatherData(for: location) { [weak self] currentWeather, error in
                guard let self = self, let currentWeather = currentWeather else { return }
                self.detailWeatherViewModels[viewModelIndex].currentWeather = currentWeather
                let briefWeather = BriefCurrentWeather(temperature: currentWeather.parameters.temperature, condition: currentWeather.condition, iconID: currentWeather.conditionIconID)
                self.locationsListViewModel.briefWeatherForFavoriteLocation[location] = briefWeather
            }
            weatherFetchingService.fetchForecastWeatherData(for: location) { [weak self] forecastResponse, error in
                guard let self = self, let forecast = forecastResponse?.list else { return }
                self.detailWeatherViewModels[viewModelIndex].forecast = forecast
            }
        }
    }
    
    private func fetchWeatherForCurrentLocation() {
        guard let currentLocation = currentLocation else { return }
        weatherFetchingService.fetchCurrentWeatherData(for: currentLocation) { [weak self] currentWeather, error in
            guard let self = self, let currentWeather = currentWeather else { return }
            self.detailWeatherViewModels[0].currentWeather = currentWeather
            let briefWeather = BriefCurrentWeather(temperature: currentWeather.parameters.temperature, condition: currentWeather.condition, iconID: currentWeather.conditionIconID)
            self.locationsListViewModel.briefWeatherForeCurrentLocation = briefWeather
        }
        weatherFetchingService.fetchForecastWeatherData(for: currentLocation) { [weak self] forecastResponse, error in
            guard let self = self, let forecast = forecastResponse?.list else { return }
            self.detailWeatherViewModels[0].forecast = forecast
        }
    }
    
    func addLocationToFavorites(withAdressString: String) {
        
    }
}

extension WeatherController: LocationServiceDelegate {
    func updateLocationWith(latitude: Double, longitude: Double) {
        geocodingService.getLocationFrom(latitude: latitude, longitude: longitude) { location in
            self.currentLocation = location
            self.fetchFavoriteLocations()
            self.createDetailWeatherViewModels()
            self.fetchWeatherForCurrentLocation()
            self.fetchWeatherForFavoriteLocations()
        }
    }
    
    
}
