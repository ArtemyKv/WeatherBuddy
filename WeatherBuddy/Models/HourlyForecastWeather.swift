//
//  HourlyForecastWeather.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 19.06.2023.
//

import Foundation

struct HourlyForecastWeather: Hashable, Equatable {
    let unixDate: Double
    let temperature: Double
    let conditionIconID: String
}
