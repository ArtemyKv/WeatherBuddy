//
//  LocationWeatherViewController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 18.09.2022.
//

import Foundation
import UIKit

class LocationWeatherViewController: UIViewController {
    
    let viewModel = DetailWeatherViewModel()
    
    var weatherView: WeatherDetailView! {
        guard isViewLoaded else { return nil }
        return (view as! WeatherDetailView)
    }
    
    func configureView() {
        viewModel.cityName.bind { [weak self] locationName in
            self?.weatherView.cityLabel.text = locationName
        }
        viewModel.areaName.bind { [weak self] areaName in
            self?.weatherView.areaLabel.text = areaName
        }
        viewModel.temperature.bind { [weak self] temperatureString in
            self?.weatherView.temperatureLabel.text = temperatureString
        }
        viewModel.weatherDescription.bind { [weak self] weatherDescription in
            self?.weatherView.descriptionLabel.text = weatherDescription
        }
        viewModel.date.bind { [weak self] dateString in
            self?.weatherView.dateLabel.text = dateString
        }
        viewModel.weatherIcon.bind { [weak self] image in
            self?.weatherView.imageView.image = image
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func loadView() {
        let weatherView = WeatherDetailView()
        self.view = weatherView
    }
}
