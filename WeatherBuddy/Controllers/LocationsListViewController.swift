//
//  LocationsListViewController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 10.10.2022.
//

import Foundation
import UIKit

class LocationsListViewController: UITableViewController {
    typealias SnapshotType = NSDiffableDataSourceSnapshot<LocationsListViewModel.Section, LocationsListCellViewModel>
    
    let weatherController = WeatherController()
    var viewModel: LocationsListViewModel!
    var dataSource: LocationsListDataSource!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupTableViewReordering()
        setupRowDeletion()
        configureNavigationItem()
        viewModel = weatherController.locationsListViewModel
        tableView.register(LocationsListTableViewCell.self, forCellReuseIdentifier: LocationsListTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        viewModel.favoriteLocationsCellViewModels.bind { [weak self] _ in
            self?.applySnapshot()
        }
        viewModel.currentLocationCellViewModel.bind { [weak self] _ in
            self?.applySnapshot()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func configureNavigationItem() {
        let addButton = UIBarButtonItem(systemItem: .add)
        addButton.tintColor = .black
        addButton.target = self
        addButton.action = #selector(addButtonTapped)
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.title = "Weather Buddy"
    }
    
    @objc func addButtonTapped() {
        let searchVC = SearchTableViewController()
        searchVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: searchVC)
        present(navigationVC, animated: true)
    }
    
    func setupDataSource() {
        let dataSource = LocationsListDataSource(tableView: tableView) { tableView, indexPath, cellViewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationsListTableViewCell.reuseIdentifier, for: indexPath) as! LocationsListTableViewCell
            cell.configureCell(withViewModel: cellViewModel)
            return cell
        }
        self.dataSource = dataSource
    }
    
    func applySnapshot() {
        var snapshot = SnapshotType()
        snapshot.appendSections(LocationsListViewModel.Section.allCases)
        if let currentLocationCellViewModel = viewModel.currentLocationCellViewModel.value {
            snapshot.appendItems([currentLocationCellViewModel], toSection: .current)
        }
        snapshot.appendItems(viewModel.favoriteLocationsCellViewModels.value, toSection: .favorite)
        dataSource.apply(snapshot)
    }
    
    func setupTableViewReordering() {
        self.dataSource.reorderingHandler = { [weak self] sourceIndex, destinationIndex in
            guard let self = self else { return }
            self.viewModel.moveCell(at: sourceIndex, to: destinationIndex)
            self.weatherController.handleReorderingFavoriteLocations(at: sourceIndex, to: destinationIndex)
        }
    }
    
    func setupRowDeletion() {
        self.dataSource.deletionHandler = { [weak self] index in
            guard let self = self else { return }
            self.viewModel.deleteCell(at: index)
            self.weatherController.handleLocationDeletion(at: index)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pageVC = WeatherPagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.initialPage = (indexPath.section != 0 ? (indexPath.row + 1) : 0)
        pageVC.detailWeatherViewModels = weatherController.detailWeatherViewModels
        self.navigationController?.pushViewController(pageVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath.section == 0 ? sourceIndexPath : proposedDestinationIndexPath
    }
}

extension LocationsListViewController: SearchTableViewControllerDelegate {
    func addLocation(withSearchResult searchResult: SearchingService.SearchResult) {
        weatherController.addLocationToFavorites(withAddressString: searchResult.title) { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    
}
