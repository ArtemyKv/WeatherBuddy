//
//  LocationsListVIewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 09.10.2022.
//

import Foundation

class LocationsListViewModel {
    
    var briefWeatherForFavoriteLocation: [Location: BriefCurrentWeather] = [:]
    var currentLocation: Location?
    var briefWeatherForeCurrentLocation: BriefCurrentWeather? {
        didSet {
            createCurrentCellViewModel()
        }
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
        guard !briefWeatherForFavoriteLocation.isEmpty else { return }
        for location in briefWeatherForFavoriteLocation.keys.sorted(by: { $0.order < $1.order }) {
            if let cellViewModel = cellViewModel(forLocation: location, isCurrentLocation: false) {
                favoriteLocationsCellViewModels.value.append(cellViewModel)
            }
        }
    }
    
    func createCellViewModelForNewLocation(location: Location) {
        guard let cellViewModel = cellViewModel(forLocation: location, isCurrentLocation: false) else { return }
        favoriteLocationsCellViewModels.value.append(cellViewModel)
    }
    
    func cellViewModel(forLocation location: Location, isCurrentLocation: Bool) -> LocationsListCellViewModel? {
        guard
            let briefWeather = isCurrentLocation ? briefWeatherForeCurrentLocation : briefWeatherForFavoriteLocation[location]
        else { return nil }
        let locationName = location.name ?? location.administrativeArea ?? "No location name"
        let cellViewModel = LocationsListCellViewModel(briefCurrentWeather: briefWeather, locationName: locationName)
        return cellViewModel
    }
    
    func moveCell(at sourceIndex: Int, to destinationIndex: Int) {
        let movedCellViewModel = self.favoriteLocationsCellViewModels.value.remove(at: sourceIndex)
        self.favoriteLocationsCellViewModels.value.insert(movedCellViewModel, at: destinationIndex)
        
        
    }
}
