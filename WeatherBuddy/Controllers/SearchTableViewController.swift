//
//  SearchController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 13.10.2022.
//

import Foundation
import UIKit

protocol SearchTableViewControllerDelegate: AnyObject {
    func addLocation(withSearchResult searchResult: SearchingService.SearchResult)
}

class SearchTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    var searchingService: SearchingService!
    
    var delegate: SearchTableViewControllerDelegate?
    
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchResults[indexPath.row]
        delegate?.addLocation(withSearchResult: searchResult)
        navigationController?.dismiss(animated: true)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.dismiss(animated: true)
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
