//
//  LocationWeatherViewController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 18.09.2022.
//

import Foundation
import UIKit

class LocationWeatherViewController: UIViewController {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<DetailWeatherViewModel.Section, DetailWeatherViewModel.Item>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<DetailWeatherViewModel.Section, DetailWeatherViewModel.Item>
    
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    let viewModel = DetailWeatherViewModel()
    var collectionViewDataSource: DataSourceType!
    
    var weatherView: WeatherDetailView! {
        guard isViewLoaded else { return nil }
        return (view as! WeatherDetailView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCurrentWeatherView()
        configureForecastCollectionView()
        
        weatherView.collectionView.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.reuseIdentifier)
    }
    
    override func loadView() {
        let weatherView = WeatherDetailView()
        self.view = weatherView
    }
}

extension LocationWeatherViewController {
    func configureCurrentWeatherView() {
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
    
    func configureForecastCollectionView() {
        weatherView.collectionView.collectionViewLayout = createCollectionViewLayout()
        weatherView.collectionView.dataSource = collectionViewDataSource
        createDataSource()
        viewModel.hourlyForecastCellViewModels.bind { [weak self] hourlyForecasts in
            self?.applySnapshot(with: hourlyForecasts)
        }
    }
}

extension LocationWeatherViewController {
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        
        let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
            elementKind: LocationWeatherViewController.sectionBackgroundDecorationElementKind)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.decorationItems = [backgroundDecoration]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.register(SectionBackgroundDecorationView.self,
                        forDecorationViewOfKind: LocationWeatherViewController.sectionBackgroundDecorationElementKind)
        return layout
        
    }
    
    func createDataSource() {
        collectionViewDataSource = DataSourceType.init(collectionView: weatherView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! HourlyWeatherCollectionViewCell
            switch itemIdentifier {
                case .hourly(let cellViewModel):
                    cell.hourLabel.text = cellViewModel.hour
                    cell.temperatureLabel.text = cellViewModel.temperature
                    cell.imageView.image = cellViewModel.weatherIcon
            }
            return cell
        })
    }
    
    func applySnapshot(with forecastViewModels: [HourlyForecastCellViewModel]) {
        var snapshot = SnapshotType()
        snapshot.appendSections([.hourly])
        snapshot.appendItems(forecastViewModels.map { DetailWeatherViewModel.Item.hourly($0) }, toSection: .hourly)
        collectionViewDataSource.apply(snapshot)
    }
}
