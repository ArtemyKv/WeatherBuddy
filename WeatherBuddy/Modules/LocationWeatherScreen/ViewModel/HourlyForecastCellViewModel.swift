//
//  HourlyForecastCellViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 20.09.2022.
//

import Foundation
import UIKit.UIImage

class HourlyForecastCellViewModel: ForecastCellViewModel {
    
    private var hourlyForecastWeather: HourlyForecastWeather {
        didSet {
            configure()
        }
    }
    
    private var timeZone: TimeZone?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    
    var hour = ""
    var temperature = ""
    var weatherIcon: UIImage? = nil
    
    private func configure() {
        dateFormatter.timeZone = timeZone
        hour = dateFormatter.string(from: Date(timeIntervalSince1970: hourlyForecastWeather.unixDate))
        temperature = "\(Int(hourlyForecastWeather.temperature))º"
        weatherIcon = UIImage(named: hourlyForecastWeather.conditionIconID)
    }
    
    init(hourlyForecastWeather: HourlyForecastWeather, timeZone: TimeZone?) {
        self.hourlyForecastWeather = hourlyForecastWeather
        self.timeZone = timeZone
        configure()
    }
    
}

extension HourlyForecastCellViewModel: Hashable {
    static func == (lhs: HourlyForecastCellViewModel, rhs: HourlyForecastCellViewModel) -> Bool {
        return lhs.hourlyForecastWeather == rhs.hourlyForecastWeather
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hourlyForecastWeather)
    }
}
