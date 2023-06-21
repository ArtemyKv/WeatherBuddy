//
//  DailyForecastCellViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 20.09.2022.
//

import Foundation
import UIKit.UIImage

final class DailyForecastCellViewModel: ForecastCellViewModel {
    
    private var dailyForecastWeather: DailyForecastWeather {
        didSet {
            configure()
        }
    }
    
    var minTemperature: String = ""
    var maxTemperature: String = ""
    var weekDayString: String = ""
    var weatherIcon: UIImage? = nil
    
    init(dailyForecastWeather: DailyForecastWeather) {
        self.dailyForecastWeather = dailyForecastWeather
        configure()
    }
    
    private func configure() {
        let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        weekDayString = weekdays[dailyForecastWeather.weekday - 1]
        minTemperature = "\(Int(dailyForecastWeather.minTemp))º"
        maxTemperature = "\(Int(dailyForecastWeather.maxTemp))º"
        weatherIcon = UIImage(named: averageWeatherIconID())
    }
    
    private func averageWeatherIconID() -> String {
        var iconsCountDict = [String: Int]()
        for icon in dailyForecastWeather.icons {
            let condition = String(icon[..<icon.index(before: icon.endIndex)])
            iconsCountDict[condition, default: 0] += 1
        }
        let maxCountIcon = iconsCountDict.max { $0.value < $1.value }
        return "\(maxCountIcon!.key)d"
    }
}

extension DailyForecastCellViewModel: Hashable {
    static func == (lhs: DailyForecastCellViewModel, rhs: DailyForecastCellViewModel) -> Bool {
        return lhs.dailyForecastWeather == rhs.dailyForecastWeather
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dailyForecastWeather)
    }
}


