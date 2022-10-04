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
    
    var forecastCellViewModels: Box<[Section: [ForecastCellViewModel]]> = Box(value: [:])
    
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
    var feelsLikeTemp = Box(value: "")
    var pressure = Box(value: "")
    var humidity = Box(value: "")
    var visibility = Box(value: "")
    var windSpeed = Box(value: "")
    var windDirection = Box(value: "")
    var windDirectionImage: Box<UIImage?> = Box(value: nil)
    
    //MARK: - CollectionView sections and items
    enum Section: CaseIterable {
        case hourly
        case daily
    }
    
    enum Item: Hashable {
        case hourly(HourlyForecastCellViewModel)
        case daily(DailyForecastCellViewModel)
    }
    
    //MARK: - Methods
    private func configureBasicWeatherInfo(with weather: Weather) {
        //Current weather info
        cityName.value = location?.name ?? ""
        dateFormatter.timeZone = location?.timezone
        
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
        
        //Weather parameters info
        feelsLikeTemp.value = "\(Int(weather.parameters.feelsLikeTemperature))º"
        pressure.value = "\(weather.parameters.pressure) hPa"
        humidity.value = "\(weather.parameters.humidity) %"
        visibility.value = "\(weather.visibility) m"
        windSpeed.value = "\(weather.wind.speed) meter/sec"
        
        let windDirectionInfo = getWindDirectionWith(degrees: weather.wind.degrees)
        windDirection.value = windDirectionInfo.windDirection.rawValue
        windDirectionImage.value = windDirectionInfo.windDirectionImage
        
    }
    
    private func configureForecastViewModels(with forecast: [Weather]) {
        configureHourlyForecastViewModel(with: forecast)
        configureDailyForecastViewModel(with: forecast)
    }
    
    private func configureHourlyForecastViewModel(with forecast: [Weather]) {
        forecastCellViewModels.value[.hourly] = []
        let oneDayWeatherItemsArray = Array(forecast.prefix(through: 15))
        oneDayWeatherItemsArray.forEach {
            self.forecastCellViewModels.value[.hourly]?.append(HourlyForecastCellViewModel(weatherItem: $0, timeZone: location?.timezone))
        }
    }
    
    private func configureDailyForecastViewModel(with forecast: [Weather]) {
        forecastCellViewModels.value[.daily] = []
        let calendar = Calendar.current
        var dailyForecastsDict: [Int: DailyForecastWeather] = [:]
        for item in forecast {
            let weekdayNumber = calendar.component(.weekday, from: Date(timeIntervalSince1970: item.unixDate))
            let dayNumber = calendar.component(.day, from: Date(timeIntervalSince1970: item.unixDate))
            let temperature = item.parameters.temperature
            guard let parameters = dailyForecastsDict[dayNumber] else {
                dailyForecastsDict[dayNumber] = DailyForecastWeather(minTemp: temperature,
                                                                         maxTemp: temperature,
                                                                         icons: [item.conditionIconID],
                                                                         weekday: weekdayNumber)
                continue
            }
            
            if temperature < parameters.minTemp {
                dailyForecastsDict[dayNumber]?.minTemp = temperature
            } else if temperature >  parameters.maxTemp {
                dailyForecastsDict[dayNumber]?.maxTemp = temperature
            }
            dailyForecastsDict[dayNumber]?.icons.append(item.conditionIconID)
        }
        
        for key in dailyForecastsDict.keys.sorted(by: <) {
            self.forecastCellViewModels.value[.daily]?.append(DailyForecastCellViewModel(dailyForecastWeather: dailyForecastsDict[key]!))
        }
    }
    
    private func fetchWeatherData(for location: Location) {
        weatherFetchingService.fetchCurrentWeatherData(for: location) { [weak self] weather, error in
            guard let self = self, let weather = weather else { return }
            self.currentWeather = weather
            self.configureBasicWeatherInfo(with: weather)
        }
        weatherFetchingService.fetchForecastWeatherData(for: location) { [weak self] response, error in
            guard let self = self, let forecast = response?.list else { return }
            self.forecast = forecast
            self.configureForecastViewModels(with: forecast)
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

extension DetailWeatherViewModel {
    
    enum WindDirection: String {
        case north = "N"
        case northWest = "NW"
        case west = "W"
        case southWest = "SW"
        case south = "S"
        case southEast = "SE"
        case east = "E"
        case northEast = "NE"
    }
    
    func getWindDirectionWith(degrees: Double) -> (windDirection: WindDirection, windDirectionImage: UIImage?) {
        switch degrees {
        case 0..<25:
                return (.north, UIImage(systemName: "arrow.up"))
        case 25..<65:
            return (.northEast, UIImage(systemName: "arrow.up.right"))
        case 65..<115:
            return (.east, UIImage(systemName: "arrow.right"))
        case 115..<155:
            return (.southEast, UIImage(systemName: "arrow.down.right"))
        case 155..<205:
            return (.south, UIImage(systemName: "arrow.down"))
        case 205..<245:
            return (.southWest, UIImage(systemName: "arrow.down.left"))
        case 245..<295:
            return (.west, UIImage(systemName: "arrow.left"))
        case 295..<335:
            return (.northWest, UIImage(systemName: "arrow.up.left"))
        default:
            return (.north, UIImage(systemName: "arrow.up"))
        }
    }
}
