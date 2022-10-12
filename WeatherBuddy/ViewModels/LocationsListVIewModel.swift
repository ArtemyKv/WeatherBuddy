//
//  LocationsListVIewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 09.10.2022.
//

import Foundation

class LocationsListViewModel {
    
    var briefWeatherForFavoriteLocation: [Location: BriefCurrentWeather] = [:] {
        didSet {
            createFavoriteCellViewModels()
        }
    }
    var currentLocation: Location?
    var briefWeatherForeCurrentLocation: BriefCurrentWeather? {
        didSet {
            createCurrentCellViewModel()
        }
    }
    
    var favoriteLocationsCellViewModels: Box<[LocationsListCellViewModel]> = Box(value: [])
    var currentLocationCellViewModel: Box<LocationsListCellViewModel?> = Box(value: nil)
    
    func createFavoriteCellViewModels() {
        guard !briefWeatherForFavoriteLocation.isEmpty else { return }

        for location in briefWeatherForFavoriteLocation.keys.sorted(by: { $0.order < $1.order }) {
            let briefWeather = briefWeatherForFavoriteLocation[location]!
            let locationName = location.name ?? location.administrativeArea ?? "No location name"
            let cellViewModel = LocationsListCellViewModel(briefCurrentWeather: briefWeather, locationName: locationName)
            favoriteLocationsCellViewModels.value.append(cellViewModel)
        }
    }
    
    func createCurrentCellViewModel() {
        guard let location = currentLocation, let briefWeather = briefWeatherForeCurrentLocation else { return }
        let locationName = location.name ?? location.administrativeArea ?? "No location name"
        let cellViewModel = LocationsListCellViewModel(briefCurrentWeather: briefWeather, locationName: locationName)
        currentLocationCellViewModel.value = cellViewModel
    }
}
