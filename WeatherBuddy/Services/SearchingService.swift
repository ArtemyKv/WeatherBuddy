//
//  SearchingService.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 14.10.2022.
//

import MapKit

protocol SearchingServiceDelegate: AnyObject {
    func searchResultsUpdated(withResults results: [SearchingService.SearchResult])
}

class SearchingService: NSObject {
    let searchCompleter = MKLocalSearchCompleter()
    
    weak var delegate: SearchingServiceDelegate?
    
    private func setupCompleter() {
        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(.world)
        searchCompleter.resultTypes = MKLocalSearchCompleter.ResultType.address
    }
    
    func startSearch(withSearchString searchString: String) {
        searchCompleter.queryFragment = searchString
    }
    
    override init() {
        super.init()
        setupCompleter()
    }
}

extension SearchingService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let searchResults = completer.results.map { SearchResult(title: $0.title, subtitle: $0.subtitle) }
        delegate?.searchResultsUpdated(withResults: searchResults)
    }
}

extension SearchingService {
    struct SearchResult {
        let title: String
        let subtitle: String
    }
}
