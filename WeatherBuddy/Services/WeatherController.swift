//
//  WeatherController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 05.10.2022.
//

import Foundation
import CoreData

final class WeatherController {
    //MARK: - Static properties (notification names)
    static let didSetLocationsNotification = Notification.Name("WeatherController.didSetLocations")
    static let didSetWeatherForCurrentLocationNotification = Notification.Name("WeatherController.didSetWeatherForCurrentLocation")
    static let didSetWeatherForFavoriteLocationsNotification = Notification.Name("WeatherController.didSetWeatherForFavoriteLocations")
    
    //MARK: - Service properties
    let coreDataStack: CoreDataStack
    let geocodingService: GeocodingService
    let locationService: LocationService
    let weatherFetchingService: WeatherFetchingService
        
    //MARK: - Location properties
    private var favoriteLocations: [Location] = []
    private var _currentLocation: Location?
    
    //MARK: - Fetched Weather
    var currentLocationWeather: Weather?
    var currentLocationForecast: [Weather] = []
    
    var weatherByLocation: [Location: Weather] = [:]
    var forecastByLocation: [Location: [Weather]] = [:]
    
    //MARK: - Init
    init(locationService: LocationService, geocodingService: GeocodingService, weatherFetchingService: WeatherFetchingService, coreDataStack: CoreDataStack) {
        self.locationService = locationService
        self.geocodingService = geocodingService
        self.weatherFetchingService = weatherFetchingService
        self.coreDataStack = coreDataStack
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
            NotificationCenter.default.post(name: WeatherController.didSetLocationsNotification, object: nil)
        } catch let error as NSError {
            print("Unable to fetch \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Weather Fethcing methods
    private func fetchWeatherForCurrentLocation() {
        guard let currentLocation = _currentLocation else { return }
        let group = DispatchGroup()
        group.enter()
        weatherFetchingService.fetchCurrentWeatherData(for: currentLocation) { [weak self] currentWeather, error in
            guard let self = self, let currentWeather = currentWeather else { return }
            self.currentLocationWeather = currentWeather
            group.leave()
        }
        group.enter()
        weatherFetchingService.fetchForecastWeatherData(for: currentLocation) { [weak self] forecastResponse, error in
            guard let self = self, let forecast = forecastResponse?.list else { return }
            self.currentLocationForecast = forecast
            group.leave()
        }
        
        group.notify(queue: .main) {
            NotificationCenter.default.post(name: WeatherController.didSetWeatherForCurrentLocationNotification, object: nil)
        }
    }
    
    func fetchWeatherForFavoriteLocation(location: Location, completion: @escaping () -> ()) {
        let group = DispatchGroup()
        group.enter()
        weatherFetchingService.fetchCurrentWeatherData(for: location) { [weak self] currentWeather, error in
            guard let self = self, let currentWeather = currentWeather else { return }
            self.weatherByLocation[location] = currentWeather
            group.leave()
        }
        group.enter()
        weatherFetchingService.fetchForecastWeatherData(for: location) { [weak self] forecastResponse, error in
            guard let self = self, let forecast = forecastResponse?.list else { return }
            self.forecastByLocation[location] = forecast
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func fetchWeatherForFavoriteLocations() {
        let group = DispatchGroup()
        for location in favoriteLocations {
            group.enter()
            fetchWeatherForFavoriteLocation(location: location) {
                group.leave()
            }
        }
        group.notify(queue: .main) {
            NotificationCenter.default.post(name: WeatherController.didSetWeatherForFavoriteLocationsNotification, object: nil)
        }
    }
    
    //MARK: - Manage locations
    
    func currentLocation() -> Location? {
        return _currentLocation
    }
    
    func favoriteLocationsCount() -> Int {
        return favoriteLocations.count
    }
    
    func favoriteLocation(at index: Int) -> Location? {
        guard index < favoriteLocationsCount() else { return nil }
        return favoriteLocations[index]
    }
    
    func addLocationToFavorites(_ location: Location, completion: @escaping () ->()) {
        location.order = Int32(favoriteLocationsCount())
        coreDataStack.saveContext()
        favoriteLocations.append(location)
        
        fetchWeatherForFavoriteLocation(location: location) {
            completion()
        }
    }
    
    func moveFavoriteLocation(from sourceIndex: Int, to destinationIndex: Int) {
        let location = self.favoriteLocations.remove(at: sourceIndex)
        self.favoriteLocations.insert(location, at: destinationIndex)
        updateLocationsOrder()
        coreDataStack.saveContext()
    }
    
    func removeLocationFromFavorites( at index: Int) {
        let location = favoriteLocations.remove(at: index)
        coreDataStack.managedContext.delete(location)
        updateLocationsOrder()
        coreDataStack.saveContext()
    }
    
    private func updateLocationsOrder() {
        for (i, location) in favoriteLocations.enumerated() {
            location.order = Int32(i)
        }
    }
    
    //MARK: - Make briefWeather
    
    func briefWeather(forLocation location: Location, isCurrentLocation: Bool) -> BriefCurrentWeather? {
        guard let currentWeather = isCurrentLocation ? currentLocationWeather : weatherByLocation[location]
        else { return nil }
        let briefWeather = BriefCurrentWeather(temperature: currentWeather.parameters.temperature, condition: currentWeather.condition, iconID: currentWeather.conditionIconID)
        return briefWeather
    }
}

extension WeatherController: LocationServiceDelegate {
    func updateLocationWith(latitude: Double, longitude: Double) {
        geocodingService.getLocationFrom(latitude: latitude, longitude: longitude) { [weak self] location in
            guard let self = self else { return }
            self._currentLocation = location
            self.fetchFavoriteLocations()
            self.fetchWeatherForCurrentLocation()
            self.fetchWeatherForFavoriteLocations()
        }
    }
}
