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
    let viewModel: SearchViewModel
            
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        setupNavigationItem()
        setupBindings()
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
    }
    
    func setupSearchController() {
        searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func setupNavigationItem() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "New Location"
    }
    
    func setupBindings() {
        viewModel.searchResults.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let content = viewModel.makeContentForCell(at: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = content.title
        config.secondaryText = content.subtitle
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.rowSelected(at: indexPath)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.cancelButtonClicked()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChange(searchText)
    }
}
