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
    
    func fetchWeatherForFavoriteLocation(location: Location, detailViewModelIndex: Int, completion: @escaping () -> ()) {
        let group = DispatchGroup()
        group.enter()
        weatherFetchingService.fetchCurrentWeatherData(for: location) { [weak self] currentWeather, error in
            guard let self = self, let currentWeather = currentWeather else { return }
            self.detailWeatherViewModels[detailViewModelIndex].currentWeather = currentWeather
            let briefWeather = BriefCurrentWeather(temperature: currentWeather.parameters.temperature, condition: currentWeather.condition, iconID: currentWeather.conditionIconID)
            self.locationsListViewModel.briefWeatherForFavoriteLocation[location] = briefWeather
            group.leave()
        }
        group.enter()
        weatherFetchingService.fetchForecastWeatherData(for: location) { [weak self] forecastResponse, error in
            guard let self = self, let forecast = forecastResponse?.list else { return }
            self.detailWeatherViewModels[detailViewModelIndex].forecast = forecast
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func fetchWeatherForFavoriteLocations() {
        let group = DispatchGroup()
        for (i, location) in favoriteLocations.enumerated() {
            group.enter()
            let viewModelIndex = i + 1
            fetchWeatherForFavoriteLocation(location: location, detailViewModelIndex: viewModelIndex) {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.locationsListViewModel.createInitialFavoriteCellViewModels()
        }
    }
    
    func addLocationToFavorites(withAddressString addressString: String, completion: @escaping () ->()) {
        geocodingService.getLocation(from: addressString) { [weak self] location in
            guard let self = self else { return }
            location.order = Int32(self.favoriteLocations.count)
            self.coreDataStack.saveContext()
            self.favoriteLocations.append(location)
            let weatherViewModel = DetailWeatherViewModel(location: location)
            self.detailWeatherViewModels.append(weatherViewModel)
            
            let viewModelIndex = self.detailWeatherViewModels.count - 1
            self.fetchWeatherForFavoriteLocation(location: location, detailViewModelIndex: viewModelIndex) {
                self.locationsListViewModel.createCellViewModelForNewLocation(location: location)
                completion()
            }
        }
    }
}

extension WeatherController: LocationServiceDelegate {
    func updateLocationWith(latitude: Double, longitude: Double) {
        geocodingService.getLocationFrom(latitude: latitude, longitude: longitude) { [weak self] location in
            guard let self = self else { return }
            self.currentLocation = location
            self.fetchFavoriteLocations()
            self.createDetailWeatherViewModels()
            self.fetchWeatherForCurrentLocation()
            self.fetchWeatherForFavoriteLocations()
        }
    }
}
