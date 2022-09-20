//
//  CurrentWeatherViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 19.09.2022.
//

import Foundation
import UIKit.UIImage

class DetailWeatherViewModel {
    //MARK: - Model properties
    private var location: Location?
    private var currentWeather: Weather?
    private var forecast: [Weather]?
    
    //MARK: - Service properties
    private let geocodingService = GeocodingService()
    private let weatherFetchingService = WeatherFetchingService()
    private let locationService = LocationService()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    //MARK: - View properties
    var cityName = Box(value: "")
    var areaName = Box(value: "")
    var temperature = Box(value: "")
    var weatherDescription = Box(value: "")
    var date = Box(value: "")
    var weatherIcon: Box<UIImage?> = Box(value: nil)
    
    //MARK: - Methods
    private func configureBasicWeatherInfo(with weather: Weather) {
        cityName.value = location?.name ?? ""
        
        if let area = location?.administrativeArea, let country = location?.country {
            areaName.value = area + ", " + country
        } else if let area = location?.administrativeArea, location?.country == nil {
            areaName.value = area
        } else {
            areaName.value = location?.country ?? " "
        }
        
        temperature.value = "\(Int(weather.parameters.temperature))º"
        weatherDescription.value = weather.description
        date.value = dateFormatter.string(from: Date())
        weatherIcon.value = UIImage(named: weather.conditionIconID)
        print(location)
    }
    
    private func fetchWeatherData(for location: Location) {
        weatherFetchingService.fetchCurrentWeatherData(for: location) { [weak self] weather, error in
            guard let self = self, let weather = weather else { return }
            self.configureBasicWeatherInfo(with: weather)
        }
    }
    
    init() {
        locationService.delegate = self
    }
    
}

extension DetailWeatherViewModel: LocationServiceDelegate {
    func updateLocationWith(latitude: Double, longitude: Double) {
        geocodingService.getLocationFrom(latitude: latitude, longitude: longitude) { [weak self] location in
            guard let self = self else { return }
            self.location = location
            self.fetchWeatherData(for: location)
        }
    }
    
    
    
    
}
