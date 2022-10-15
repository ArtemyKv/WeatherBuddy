//
//  SearchController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 13.10.2022.
//

import Foundation
import UIKit

class SearchTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    var weatherController: WeatherController!
    var searchingService: SearchingService!
    
    var searchResults: [SearchingService.SearchResult] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        searchingService = SearchingService()
        searchingService.delegate = self
        searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "New Location"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let searchResult = searchResults[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = searchResult.title
        config.secondaryText = searchResult.subtitle
        cell.contentConfiguration = config
        return cell
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.dismiss(animated: true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingService.startSearch(withSearchString: searchText)
    }
}

extension SearchTableViewController: SearchingServiceDelegate {
    func searchResultsUpdated(withResults results: [SearchingService.SearchResult]) {
        self.searchResults = results
        tableView.reloadData()
    }
}
