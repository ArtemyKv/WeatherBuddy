//
//  LocationsListVIewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 09.10.2022.
//

import Foundation

final class LocationsListViewModel {
    
    private let weatherController: WeatherController
    private let coordinator: MainCoordinatorProtocol
    
    var favoriteLocationsCellViewModels: Box<[LocationsListCellViewModel]> = Box(value: [])
    var currentLocationCellViewModel: Box<LocationsListCellViewModel?> = Box(value: nil)
    
    enum Section: CaseIterable {
        case current
        case favorite
    }
    
    init(weatherController: WeatherController, coordinator: MainCoordinatorProtocol) {
        self.weatherController = weatherController
        self.coordinator = coordinator
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
            selector: #selector(updateCurrentLocationCellViewModel),
            name: WeatherController.didSetWeatherForCurrentLocationNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateFavoriteLocationsCellViewModels),
            name: WeatherController.didSetWeatherForFavoriteLocationsNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(addLocationToFavorites),
            name: SearchWeatherViewModel.addLocationToFavoritesNotification,
            object: nil
        )
    }
    
    @objc private func makeCellViewModels() {
        makeCurrentLocationCellViewModel()
        makeFavoriteLocationsCellViewModels()
    }
 
    private func makeCurrentLocationCellViewModel() {
        guard let location = weatherController.currentLocation() else { return }
        currentLocationCellViewModel.value = cellViewModel(forLocation: location, isCurrentLocation: true)
    }
    
    private func makeFavoriteLocationsCellViewModels() {
        for i in 0..<weatherController.favoriteLocationsCount() {
            let location = weatherController.favoriteLocation(at: i)!
            let cellViewModel = cellViewModel(forLocation: location, isCurrentLocation: false)
            favoriteLocationsCellViewModels.value.append(cellViewModel)
        }
    }
    
    @objc private func updateCurrentLocationCellViewModel() {
        guard let location = weatherController.currentLocation(),
              let cellViewModel = currentLocationCellViewModel.value else { return }
        updateCellViewModel(cellViewModel, forLocation: location, isCurrentLocation: true)
    }
    
    @objc private func updateFavoriteLocationsCellViewModels() {
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
    
    @objc private func addLocationToFavorites(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo, let location = userInfo["Location"] as? Location else { return }
        weatherController.addLocationToFavorites(location) { [weak self] in
            self?.makeCellViewModelForNewLocation(location: location)
        }
    }
    
    private func makeCellViewModelForNewLocation(location: Location) {
        let cellViewModel = cellViewModel(forLocation: location, isCurrentLocation: false)
        favoriteLocationsCellViewModels.value.append(cellViewModel)
        updateCellViewModel(cellViewModel, forLocation: location, isCurrentLocation: false)
    }
    
    private func cellViewModel(forLocation location: Location, isCurrentLocation: Bool) -> LocationsListCellViewModel {
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
        coordinator.presentSearchScreen()
    }
    
    func rowSelected(at indexPath: IndexPath) {
        let startPage = indexPath.section == 0 ? 0 : (indexPath.row + 1)
        coordinator.presentWeatherPagesScreen(startPage: startPage)
        
    }
}
