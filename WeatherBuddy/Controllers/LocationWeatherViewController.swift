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
        weatherView.collectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier)
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
        viewModel.forecastCellViewModels.bind { [weak self] cellViewModels in
            self?.applySnapshot(with: cellViewModels)
        }
    }
}

extension LocationWeatherViewController {
    func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            let section: NSCollectionLayoutSection
            
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.4))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
                group.contentInsets.top = 10
                group.contentInsets.bottom = 10
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

                section = NSCollectionLayoutSection(group: group)
                section.contentInsets.top = 10
                section.contentInsets.bottom = 10
                
            }
            
            let backgroundDecoration = NSCollectionLayoutDecorationItem.background(
                elementKind: LocationWeatherViewController.sectionBackgroundDecorationElementKind)
            section.decorationItems = [backgroundDecoration]
    
            return section
        }
        
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.interSectionSpacing = 32
        layout.configuration = layoutConfig
        
        layout.register(SectionBackgroundDecorationView.self,
                        forDecorationViewOfKind: LocationWeatherViewController.sectionBackgroundDecorationElementKind)
        return layout
        
    }
    
    func createDataSource() {
        collectionViewDataSource = DataSourceType(collectionView: weatherView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
                case .hourly(let hourlyCellViewModel):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! HourlyWeatherCollectionViewCell
                    cell.hourLabel.text = hourlyCellViewModel.hour
                    cell.temperatureLabel.text = hourlyCellViewModel.temperature
                    cell.imageView.image = hourlyCellViewModel.weatherIcon
                    return cell
                case .daily(let dailyCellViewModel):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! DailyWeatherCollectionViewCell
                    cell.weekdayLabel.text = dailyCellViewModel.weekDayString
                    cell.minTempLabel.text = dailyCellViewModel.minTemperature
                    cell.maxTempLabel.text = dailyCellViewModel.maxTemperature
                    cell.imageView.image = dailyCellViewModel.weatherIcon
                    return cell
            }
        })
    }
    
    func applySnapshot(with cellViewModels: [DetailWeatherViewModel.Section: [ForecastCellViewModel]]) {
        var snapshot = SnapshotType()
        for section in DetailWeatherViewModel.Section.allCases {
            snapshot.appendSections([section])
            let viewModels = cellViewModels[section,default: []]
            var items = [DetailWeatherViewModel.Item]()
            
            switch section {
                case .hourly:
                    items = viewModels.map { DetailWeatherViewModel.Item.hourly($0 as! HourlyForecastCellViewModel) }
                case .daily:
                    items = viewModels.map { DetailWeatherViewModel.Item.daily($0 as! DailyForecastCellViewModel) }
            }
            snapshot.appendItems(items, toSection: section)
        }
        collectionViewDataSource.apply(snapshot)
    }
}
