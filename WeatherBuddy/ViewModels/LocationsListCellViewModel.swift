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
    
    func configureViewModel() {
        temperature = "\(Int(briefCurrentWeather.temperature))º"
        location = locationName
        condition = briefCurrentWeather.condition
        image = UIImage(named: briefCurrentWeather.iconID)
    }
    
    init(briefCurrentWeather: BriefCurrentWeather, locationName: String) {
        self.briefCurrentWeather = briefCurrentWeather
        self.locationName = locationName
        configureViewModel()
    }
}
