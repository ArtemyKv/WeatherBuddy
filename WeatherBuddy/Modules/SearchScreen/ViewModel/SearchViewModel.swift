//
//  SearchViewModel.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 14.06.2023.
//

import Foundation

protocol SearchViewModelDelegate: AnyObject {
    func addLocation(withSearchResult searchResult: SearchingService.SearchResult)
}

final class SearchViewModel {
    
    var coordinator: Coordinator!
    var searchingService: SearchingService!
    
    weak var delegate: SearchViewModelDelegate?
    
    var searchResults: Box<[SearchingService.SearchResult]> = Box(value: [])
    
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
        delegate?.addLocation(withSearchResult: searchResult)
        coordinator.dismissModalScreen()
    }
    
    func cancelButtonClicked() {
        coordinator.dismissModalScreen()
    }
    
    func searchTextDidChange(_ searchText: String) {
        searchingService.startSearch(withSearchString: searchText)
    }
}

extension SearchViewModel: SearchingServiceDelegate {
    func searchResultsUpdated(withResults results: [SearchingService.SearchResult]) {
        self.searchResults.value = results
    }
}
