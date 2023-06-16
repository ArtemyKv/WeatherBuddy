//
//  LocationsListViewController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 10.10.2022.
//

import Foundation
import UIKit

class LocationsListViewController: UIViewController {
    typealias SnapshotType = NSDiffableDataSourceSnapshot<LocationsListViewModel.Section, LocationsListCellViewModel>
    
    let viewModel: LocationsListViewModel
    var dataSource: LocationsListDataSource!
    
    let transition = PushAnimator()
    var selectedCellFrame: CGRect = .zero
    
    var locationsListView: LocationsListView! {
        guard isViewLoaded else { return nil }
        return (view as! LocationsListView)
    }
    
    var tableView: UITableView {
        return locationsListView.tableView
    }
    
    init(viewModel: LocationsListViewModel) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = LocationsListView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        setupDataSource()
        setupTableViewReordering()
        setupRowDeletion()
        configureNavigationItem()
        setupBindings()
        configureTableView()
    }
    
    func setupBindings() {
        viewModel.favoriteLocationsCellViewModels.bind { [weak self] _ in
            self?.applySnapshot(isReloadingData: false)
        }
        viewModel.currentLocationCellViewModel.bind { [weak self] _ in
            self?.applySnapshot(isReloadingData: false)
        }
    }
    
    func setupDataSource() {
        let dataSource = LocationsListDataSource(tableView: tableView) { tableView, indexPath, cellViewModel in
            let cell = tableView.dequeueReusableCell(withIdentifier: LocationsListTableViewCell.reuseIdentifier,
                                                     for: indexPath) as! LocationsListTableViewCell
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
    
    func configureTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
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
        viewModel.addButtonTapped()
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
        }
    }
    
    func setupRowDeletion() {
        self.dataSource.deletionHandler = { [weak self] index in
            guard let self = self else { return }
            self.viewModel.deleteCell(at: index)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        UIView.animate(withDuration: 0.2) {
            self.locationsListView.tableView.isEditing = editing
        }
    }
}

extension LocationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? LocationsListTableViewCell else { return }
        selectedCellFrame = selectedCell.frame
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCell.animateSelection(completion: {
            self.viewModel.rowSelected(at: indexPath)
        })
    }
    
    func tableView(_ tableView: UITableView,
                   targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
                   toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath.section == 0 ? sourceIndexPath : proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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

extension LocationsListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.operation = operation
        transition.originFrame = selectedCellFrame
        return transition
    }
}
