//
//  Weather.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 16.09.2022.
//

import Foundation

struct Weather: Codable {
    let parameters: WeatherParameters
    let visibility: Double
    let wind: Wind
    
    var condition: String {
        return conditions[0].main
    }
    var description: String {
        return conditions[0].description
    }
    var conditionIconID: String {
        return conditions[0].icon
    }
    
    private let conditions: [Conditions]
    
    enum CodingKeys: String, CodingKey {
        case parameters = "main"
        case visibility
        case wind
        case conditions = "weather"
    }
}

struct WeatherParameters: Codable {
    let temperature: Double
    let feelsLikeTemperature: Double
    let pressure: Double
    let humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLikeTemperature = "feels_like"
        case pressure
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let degrees: Double
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
}

struct Conditions: Codable {
    let main: String
    let description: String
    let icon: String
}
