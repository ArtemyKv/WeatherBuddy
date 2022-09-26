//
//  HourlyForecastViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 20.09.2022.
//

import Foundation
import UIKit.UIImage

class HourlyForecastCellViewModel: ForecastCellViewModel {
    
    var weatherItem: Weather {
        didSet {
            configureViewModel()
        }
    }
    
    var timeZone: TimeZone?
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    
    var hour = ""
    var temperature = ""
    var weatherIcon: UIImage? = nil
    
    func configureViewModel() {
        dateFormatter.timeZone = timeZone
        hour = dateFormatter.string(from: Date(timeIntervalSince1970: weatherItem.unixDate))
        temperature = "\(Int(weatherItem.parameters.temperature))º"
        weatherIcon = UIImage(named: weatherItem.conditionIconID)
    }
    
    init(weatherItem: Weather, timeZone: TimeZone?) {
        self.weatherItem = weatherItem
        self.timeZone = timeZone
        configureViewModel()
    }
    
}

extension HourlyForecastCellViewModel: Hashable {
    static func == (lhs: HourlyForecastCellViewModel, rhs: HourlyForecastCellViewModel) -> Bool {
        return lhs.weatherItem == rhs.weatherItem
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(weatherItem)
    }
}
