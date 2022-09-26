//
//  DailyForecastWeather.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 22.09.2022.
//

import Foundation

struct DailyForecastWeather: Hashable {
    var minTemp: Double
    var maxTemp: Double
    var icons: [String]
    var weekday: Int
}

