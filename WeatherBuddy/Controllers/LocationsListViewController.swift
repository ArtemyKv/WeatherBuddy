//
//  LocationsListViewController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 10.10.2022.
//

import Foundation
import UIKit

class LocationsListViewController: UITableViewController {
    
    let weatherController = WeatherController()
    var viewModel: LocationsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .add)
        self.navigationItem.title = "Weather Buddy"
        viewModel = weatherController.locationsListViewModel
        tableView.register(LocationsListTableViewCell.self, forCellReuseIdentifier: LocationsListTableViewCell.reuseIdentifier)
        viewModel.favoriteLocationsCellViewModels.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.currentLocationCellViewModel.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (viewModel.currentLocationCellViewModel.value != nil ? 1 : 0)
        } else {
            return viewModel.favoriteLocationsCellViewModels.value.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationsListTableViewCell.reuseIdentifier) as! LocationsListTableViewCell
        var cellViewModel: LocationsListCellViewModel
        
        if indexPath.section == 0 {
            cellViewModel = viewModel.currentLocationCellViewModel.value!
        } else {
            cellViewModel = viewModel.favoriteLocationsCellViewModels.value[indexPath.row]
        }
        
        cell.configureCell(withViewModel: cellViewModel)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pageVC = WeatherPagesViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageVC.initialPage = (indexPath.section != 0 ? (indexPath.row + 1) : 0)
        pageVC.detailWeatherViewModels = weatherController.detailWeatherViewModels
        self.navigationController?.pushViewController(pageVC, animated: true)
    }
}
