//
//  ForecastResponse.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 20.09.2022.
//

import Foundation

struct ForecastResponse: Codable {
    var list: [Weather]
}
