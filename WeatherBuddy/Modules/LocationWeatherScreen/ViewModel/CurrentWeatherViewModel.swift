//
//  CurrentWeatherViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 19.06.2023.
//

import Foundation
import UIKit.UIImage

struct CurrentWeatherViewModel {
    var cityName: String
    var areaName: String
    var temperature: String
    var weatherDescription: String
    var date: String
    var weatherIcon: UIImage?
    var feelsLikeTemp: String
    var pressure: String
    var humidity: String
    var visibility: String
    var windSpeed: String
    var windDirection: String
    var windDirectionImage: UIImage?
    var weatherColor: UIColor
}
