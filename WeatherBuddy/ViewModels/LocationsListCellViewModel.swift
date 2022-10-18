//
//  LocationsListCellViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 09.10.2022.
//

import Foundation
import UIKit.UIImage

class LocationsListCellViewModel {
    let briefCurrentWeather: BriefCurrentWeather
    let locationName: String
    
    var temperature = ""
    var location = ""
    var condition = ""
    var image: UIImage? = nil
    var backgroundColor: UIColor = .clear
    
    func configureViewModel() {
        temperature = "\(Int(briefCurrentWeather.temperature))º"
        location = locationName
        condition = briefCurrentWeather.condition
        image = UIImage(named: briefCurrentWeather.iconID)
        backgroundColor = UIColor.weatherColor(forIconID: briefCurrentWeather.iconID)
    }
    
    init(briefCurrentWeather: BriefCurrentWeather, locationName: String) {
        self.briefCurrentWeather = briefCurrentWeather
        self.locationName = locationName
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
