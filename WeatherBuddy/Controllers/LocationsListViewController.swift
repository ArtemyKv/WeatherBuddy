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
        setupViewModel()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupViewModel() {
        viewModel = weatherController.locationsListViewModel
        viewModel.favoriteLocationsCellViewModels.bind { [weak self] _ in
            self?.applySnapshot(isReloadingData: false)
        }
        viewModel.currentLocationCellViewModel.bind { [weak self] _ in
            self?.applySnapshot(isReloadingData: false)
        }
    }
    
    func configureTableView() {
        tableView.register(LocationsListTableViewCell.self, forCellReuseIdentifier: LocationsListTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
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
            cellViewModel.location.bind { locationName in
                cell.locationLabel.text = locationName
            }
            cellViewModel.image.bind { image in
                cell.conditionImageView.image = image
            }
            cellViewModel.condition.bind { condition in
                cell.conditionLabel.text = condition
            }
            cellViewModel.temperature.bind { temperature in
                cell.temperatureLabel.text = temperature
            }
            cellViewModel.backgroundColor.bind { color in
                cell.contentView.backgroundColor = color
            }
            return cell
        }
        self.dataSource = dataSource
    }
    
    func applySnapshot(isReloadingData: Bool) {
        var snapshot = SnapshotType()
        snapshot.appendSections([LocationsListViewModel.Section.current])
        if let currentLocationCellViewModel = viewModel.currentLocationCellViewModel.value {
            snapshot.appendItems([currentLocationCellViewModel], toSection: .current)
        }
        if !viewModel.favoriteLocationsCellViewModels.value.isEmpty {
            snapshot.appendSections([LocationsListViewModel.Section.favorite])
            snapshot.appendItems(viewModel.favoriteLocationsCellViewModels.value, toSection: .favorite)
        }
        if isReloadingData {
            dataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            dataSource.apply(snapshot,animatingDifferences: true)
        }
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = LocationsListSectionHeader()
        if section == 0, viewModel.currentLocationCellViewModel.value != nil {
            header.titleLabel.text = "Current Location"
            return header
        } else if section == 1 {
            header.titleLabel.text = "Favorite Locations"
            return header
        } else {
            return nil
        }
    }
}

extension LocationsListViewController: SearchTableViewControllerDelegate {
    func addLocation(withSearchResult searchResult: SearchingService.SearchResult) {
        weatherController.addLocationToFavorites(withAddressString: searchResult.title) { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
}
