//
//  SearchWeatherViewController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 23.06.2023.
//

import Foundation
import UIKit

class SearchWeatherViewController: LocationWeatherViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    func setupNavigationItem() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        let searchWeatherViewModel = viewModel as! SearchWeatherViewModel
        searchWeatherViewModel.addButtonTapped()
    }
}
