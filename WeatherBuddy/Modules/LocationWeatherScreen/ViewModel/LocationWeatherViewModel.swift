//
//  LocationWeatherViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 19.09.2022.
//

import Foundation
import UIKit.UIImage

enum WeatherCollectionViewItems {
    enum Section: CaseIterable {
        case hourly
        case daily
    }

    enum Item: Hashable {
        case hourly(HourlyForecastCellViewModel)
        case daily(DailyForecastCellViewModel)
        
    }
}

protocol LocationWeatherViewModelProtocol: AnyObject {
    var location: Location? { get set }
    var currentWeather: Weather? { get set }
    var weatherForecast: [Weather]? { get set }
    
    var locationViewModel: Box<LocationViewModel?> { get set }
    var currentWeatherViewModel: Box<CurrentWeatherViewModel?> { get set }
    var forecastCellViewModelsBySection: Box<[WeatherCollectionViewItems.Section: [ForecastCellViewModel]]> { get set }
}

class LocationWeatherViewModel: LocationWeatherViewModelProtocol {
    //MARK: - Model properties
    var location: Location? {
        didSet {
            guard let location else { return }
            setupLocationViewModel(with: location)
        }
    }
    
    var currentWeather: Weather? {
        didSet {
            guard let currentWeather = currentWeather else { return }
            setupCurrentWeatherViewModel(with: currentWeather)
        }
    }
    var weatherForecast: [Weather]? {
        didSet {
            guard let forecast = weatherForecast, forecast.count > 0 else { return }
            setupForecastViewModels(with: forecast)
        }
    }
    
    var locationViewModel: Box<LocationViewModel?> = Box(value: nil)
    var currentWeatherViewModel: Box<CurrentWeatherViewModel?> = Box(value: nil)
    var forecastCellViewModelsBySection: Box<[WeatherCollectionViewItems.Section: [ForecastCellViewModel]]> = Box(value: [:])
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    //MARK: - Init
    init(location: Location?) {
        self.location = location
        if let location = location {
            setupLocationViewModel(with: location)
        }
    }
    
    //MARK: - Methods
    func setupLocationViewModel(with location: Location) {
        dateFormatter.timeZone = location.timeZone
        //Current weather info
        let cityName = location.name ?? ""
        var areaName = ""
        if let area = location.administrativeArea, let country = location.country {
            areaName = area + ", " + country
        } else if let area = location.administrativeArea, location.country == nil {
            areaName = area
        } else {
            areaName = location.country ?? " "
        }
        let date = dateFormatter.string(from: Date())
        
        locationViewModel.value = LocationViewModel(cityName: cityName, areaName: areaName, date: date)
    }
    
    func setupCurrentWeatherViewModel(with weather: Weather) {
        //Current weather info
        let temperature = "\(Int(weather.parameters.temperature))º"
        let weatherDescription = weather.description
        let weatherIcon = UIImage(named: weather.conditionIconID)
        
        //Weather parameters info
        let feelsLikeTemp = "\(Int(weather.parameters.feelsLikeTemperature))º"
        let pressure = "\(weather.parameters.pressure) hPa"
        let humidity = "\(weather.parameters.humidity) %"
        let visibility = "\(weather.visibility) m"
        let windSpeed = "\(weather.wind.speed) meter/sec"
        
        let windDirectionInfo = getWindDirectionWith(degrees: weather.wind.degrees)
        let windDirection = windDirectionInfo.windDirection.rawValue
        let windDirectionImage = windDirectionInfo.windDirectionImage
        
        let weatherColor = UIColor.weatherColor(forIconID: weather.conditionIconID)
        
        currentWeatherViewModel.value = CurrentWeatherViewModel(
            temperature: temperature,
            weatherDescription: weatherDescription,
            weatherIcon: weatherIcon,
            feelsLikeTemp: feelsLikeTemp,
            pressure: pressure,
            humidity: humidity,
            visibility: visibility,
            windSpeed: windSpeed,
            windDirection: windDirection,
            windDirectionImage: windDirectionImage,
            weatherColor: weatherColor
        )
        
    }
    
    func setupForecastViewModels(with forecast: [Weather]) {
        setupHourlyForecastViewModel(with: forecast)
        setupDailyForecastViewModel(with: forecast)
    }
    
    func setupHourlyForecastViewModel(with forecast: [Weather]) {
        guard let location else { return }
        forecastCellViewModelsBySection.value[.hourly] = []
        print(forecast.count)
        let oneDayHourlyWeatherList = forecast
            .map({HourlyForecastWeather(unixDate: $0.unixDate, temperature: $0.parameters.temperature, conditionIconID: $0.conditionIconID)})
            .prefix(through: 15)
        oneDayHourlyWeatherList.forEach {
            self.forecastCellViewModelsBySection.value[.hourly]?.append(HourlyForecastCellViewModel(hourlyForecastWeather: $0, timeZone: location.timeZone))
        }
    }
    
    private func setupDailyForecastViewModel(with forecast: [Weather]) {
        forecastCellViewModelsBySection.value[.daily] = []
        let dailyForecastByDayNumber = dailyForecastByDayNumber(forecast: forecast)
        for key in dailyForecastByDayNumber.keys.sorted(by: <) {
            self.forecastCellViewModelsBySection.value[.daily]?.append(DailyForecastCellViewModel(dailyForecastWeather: dailyForecastByDayNumber[key]!))
        }
    }
    
    private func dailyForecastByDayNumber(forecast: [Weather]) -> [Int: DailyForecastWeather] {
        let calendar = Calendar.current
        var dailyForecastByDayNumber: [Int: DailyForecastWeather] = [:]
        for item in forecast {
            let weekdayNumber = calendar.component(.weekday, from: Date(timeIntervalSince1970: item.unixDate))
            let dayNumber = calendar.component(.day, from: Date(timeIntervalSince1970: item.unixDate))
            let temperature = item.parameters.temperature
            guard let parameters = dailyForecastByDayNumber[dayNumber] else {
                dailyForecastByDayNumber[dayNumber] = DailyForecastWeather(
                    minTemp: temperature,
                    maxTemp: temperature,
                    icons: [item.conditionIconID],
                    weekday: weekdayNumber
                )
                continue
            }
            if temperature < parameters.minTemp {
                dailyForecastByDayNumber[dayNumber]?.minTemp = temperature
            } else if temperature >  parameters.maxTemp {
                dailyForecastByDayNumber[dayNumber]?.maxTemp = temperature
            }
            dailyForecastByDayNumber[dayNumber]?.icons.append(item.conditionIconID)
        }
        return dailyForecastByDayNumber
    }
}

extension LocationWeatherViewModel {
    
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
