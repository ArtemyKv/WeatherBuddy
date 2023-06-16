//
//  LocationsListVIewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 09.10.2022.
//

import Foundation

class LocationsListViewModel {
    
    var weatherController: WeatherController!
    var coordinator: Coordinator!
    
    var favoriteLocationsCellViewModels: Box<[LocationsListCellViewModel]> = Box(value: [])
    var currentLocationCellViewModel: Box<LocationsListCellViewModel?> = Box(value: nil)
    
    enum Section: CaseIterable {
        case current
        case favorite
    }
    
    init() {
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(makeCellViewModels),
            name: WeatherController.didSetLocationsNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCurrentCellViewModel),
            name: WeatherController.didSetWeatherForCurrentLocationNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFavoriteCellViewModels),
            name: WeatherController.didSetWeatherForFavoriteLocationsNotification,
            object: nil
        )
    }
    
    @objc private func makeCellViewModels() {
        makeCurrentCellViewModel()
        makeFavoriteCellViewModels()
    }
 
    private func makeCurrentCellViewModel() {
        guard let location = weatherController.currentLocation() else { return }
        currentLocationCellViewModel.value = cellViewModel(forLocation: location, isCurrentLocation: true)
    }
    
    private func makeFavoriteCellViewModels() {
        for i in 0..<weatherController.favoriteLocationsCount() {
            let location = weatherController.favoriteLocation(at: i)!
            let cellViewModel = cellViewModel(forLocation: location, isCurrentLocation: false)
            favoriteLocationsCellViewModels.value.append(cellViewModel)
        }
    }
    
    @objc private func updateCurrentCellViewModel() {
        guard let location = weatherController.currentLocation(),
              let cellViewModel = currentLocationCellViewModel.value else { return }
        updateCellViewModel(cellViewModel, forLocation: location, isCurrentLocation: true)
    }
    
    @objc private func updateFavoriteCellViewModels() {
        for i in 0..<weatherController.favoriteLocationsCount() {
            let location = weatherController.favoriteLocation(at: i)!
            let cellViewModel = favoriteLocationsCellViewModels.value[i]
            updateCellViewModel(cellViewModel, forLocation: location, isCurrentLocation: false)
        }
    }
    
    private func updateCellViewModel(_ cellViewModel: LocationsListCellViewModel, forLocation location: Location, isCurrentLocation: Bool) {
        let briefWeather = weatherController.briefWeather(forLocation: location, isCurrentLocation: isCurrentLocation)
        cellViewModel.briefCurrentWeather = briefWeather
    }
    
    func makeCellViewModelForNewLocation(location: Location) {
        let cellViewModel = cellViewModel(forLocation: location, isCurrentLocation: false)
        favoriteLocationsCellViewModels.value.append(cellViewModel)
        updateCellViewModel(cellViewModel, forLocation: location, isCurrentLocation: false)
    }
    
    func cellViewModel(forLocation location: Location, isCurrentLocation: Bool) -> LocationsListCellViewModel {
        let briefWeather = weatherController.briefWeather(forLocation: location, isCurrentLocation: isCurrentLocation)
        let locationName = location.name ?? location.administrativeArea ?? "No location name"
        let cellViewModel = LocationsListCellViewModel(locationName: locationName, briefCurrentWeather: briefWeather)
        return cellViewModel
    }
    
    func moveCell(at sourceIndex: Int, to destinationIndex: Int) {
        let movedCellViewModel = self.favoriteLocationsCellViewModels.value.remove(at: sourceIndex)
        favoriteLocationsCellViewModels.value.insert(movedCellViewModel, at: destinationIndex)
        weatherController.moveFavoriteLocation(from: sourceIndex, to: destinationIndex)
    }
    
    func deleteCell( at index: Int) {
        favoriteLocationsCellViewModels.value.remove(at: index)
        weatherController.removeLocationFromFavorites(at: index)
        
    }
    
    func addButtonTapped() {
        coordinator.presentSearchScreen(searchScreenDelegate: self)
    }
    
    func rowSelected(at indexPath: IndexPath) {
        let startPage = indexPath.section == 0 ? 0 : (indexPath.row + 1)
        coordinator.presentWeatherPagesScreen(startPage: startPage)
        
    }
}

extension LocationsListViewModel: SearchViewModelDelegate {
    func addLocation(withSearchResult searchResult: SearchingService.SearchResult) {
        weatherController.addLocationToFavorites(withAddressString: searchResult.title) { [weak self] location in
            self?.makeCellViewModelForNewLocation(location: location)
        }
    }
}
