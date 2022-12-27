//
//  LocationsListVIewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 09.10.2022.
//

import Foundation

class LocationsListViewModel {
    
    var briefWeatherForFavoriteLocation: [Location: BriefCurrentWeather?] = [:]
    var currentLocation: Location? {
        didSet {
            createCurrentCellViewModel()
        }
    }
    
    var briefWeatherForCurrentLocation: BriefCurrentWeather? {
        didSet {
            currentLocationCellViewModel.value?.briefCurrentWeather = briefWeatherForCurrentLocation
        }
    }
    
    var sortedLocations: [Location] {
        briefWeatherForFavoriteLocation.keys.sorted(by: { $0.order < $1.order })
    }
    
    var favoriteLocationsCellViewModels: Box<[LocationsListCellViewModel]> = Box(value: [])
    var currentLocationCellViewModel: Box<LocationsListCellViewModel?> = Box(value: nil)
    
    enum Section: CaseIterable {
        case current
        case favorite
    }
 
    func createCurrentCellViewModel() {
        guard let location = currentLocation else { return }
        currentLocationCellViewModel.value = cellViewModel(forLocation: location, isCurrentLocation: true)
    }
    
    func createInitialFavoriteCellViewModels() {
        for location in sortedLocations {
            let cellViewModel = cellViewModel(forLocation: location, isCurrentLocation: false)
            favoriteLocationsCellViewModels.value.append(cellViewModel)
        }
    }
    
    func updateFavoriteCellViewModels() {
        for (i, location) in sortedLocations.enumerated() {
            guard let briefWeather = briefWeatherForFavoriteLocation[location] else { continue }
            favoriteLocationsCellViewModels.value[i].briefCurrentWeather = briefWeather
        }
    }
    
    func createCellViewModelForNewLocation(location: Location) {
        let cellViewModel = cellViewModel(forLocation: location, isCurrentLocation: false)
        favoriteLocationsCellViewModels.value.append(cellViewModel)
    }
    
    func cellViewModel(forLocation location: Location, isCurrentLocation: Bool) -> LocationsListCellViewModel {
        let briefWeather = isCurrentLocation ? briefWeatherForCurrentLocation : briefWeatherForFavoriteLocation[location]!
        let locationName = location.name ?? location.administrativeArea ?? "No location name"
        let cellViewModel = LocationsListCellViewModel(locationName: locationName, briefCurrentWeather: briefWeather)
        return cellViewModel
    }
    
    func moveCell(at sourceIndex: Int, to destinationIndex: Int) {
        let movedCellViewModel = self.favoriteLocationsCellViewModels.value.remove(at: sourceIndex)
        self.favoriteLocationsCellViewModels.value.insert(movedCellViewModel, at: destinationIndex)
    }
    
    func deleteCell( at index: Int) {
        self.favoriteLocationsCellViewModels.value.remove(at: index)
        
    }
}
