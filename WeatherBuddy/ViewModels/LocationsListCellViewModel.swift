//
//  LocationsListCellViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 09.10.2022.
//

import Foundation
import UIKit.UIImage

class LocationsListCellViewModel {
    var briefCurrentWeather: BriefCurrentWeather? {
        didSet {
            configureViewModel()
        }
    }
    let locationName: String
    
    var temperature = Box(value: "--")
    var location = Box(value: " ")
    var condition = Box(value: "--")
    var image = Box<UIImage?>(value: nil)
    var backgroundColor = Box(value: UIColor.cyan)
    
    
    func configureViewModel() {
        location.value = locationName
        if let briefCurrentWeather = briefCurrentWeather {
            temperature.value = "\(Int(briefCurrentWeather.temperature))º"
            condition.value = briefCurrentWeather.condition
            image.value = UIImage(named: briefCurrentWeather.iconID)
            backgroundColor.value = UIColor.weatherColor(forIconID: briefCurrentWeather.iconID)
        }
    }
    
    init(locationName: String, briefCurrentWeather: BriefCurrentWeather? = nil) {
        self.locationName = locationName
        self.briefCurrentWeather = briefCurrentWeather
        configureViewModel()
    }
}

extension LocationsListCellViewModel: Hashable {
    static func == (lhs: LocationsListCellViewModel, rhs: LocationsListCellViewModel) -> Bool {
        (lhs.briefCurrentWeather == rhs.briefCurrentWeather) && (lhs.locationName == rhs.locationName)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(locationName)
        hasher.combine(briefCurrentWeather)
    }
    
}
