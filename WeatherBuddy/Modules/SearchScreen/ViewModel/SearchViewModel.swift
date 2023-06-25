//
//  SearchViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 14.06.2023.
//

import Foundation

final class SearchViewModel {
    
    private let searchingService: SearchingService
    private let geocodingService: GeocodingService
    private weak var coordinator: SearchCoordinatorProtocol!
        
    var searchResults: Box<[SearchingService.SearchResult]> = Box(value: [])
    
    init(coordinator: SearchCoordinatorProtocol, searchingService: SearchingService, geocodingService: GeocodingService) {
        self.coordinator = coordinator
        self.searchingService = searchingService
        self.geocodingService = geocodingService
    }
    
    func numberOfRows() -> Int {
        return searchResults.value.count
    }
    
    func makeContentForCell(at indexPath: IndexPath) -> (title: String, subtitle: String) {
        guard indexPath.row < searchResults.value.count else { return ("", "") }
        let searchResult = searchResults.value[indexPath.row]
        return (title: searchResult.title, subtitle: searchResult.subtitle)
    }
    
    func rowSelected(at indexPath: IndexPath) {
        guard indexPath.row < searchResults.value.count else { return }
        let searchResult = searchResults.value[indexPath.row]
        geocodingService.getLocation(from: searchResult.title) { [weak self] location in
            self?.coordinator.presentSearchWeatherScreen(location: location)
        }
    }
    
    func cancelButtonClicked() {
        coordinator.removeSearchScreen()
    }
    
    func searchTextDidChange(_ searchText: String) {
        searchingService.startSearch(withSearchString: searchText)
    }
    
    func searchScreenSwipedDown() {
        coordinator.finish()
    }
    
}

extension SearchViewModel: SearchingServiceDelegate {
    func searchResultsUpdated(withResults results: [SearchingService.SearchResult]) {
        self.searchResults.value = results
    }
}
