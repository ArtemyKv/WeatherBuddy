//
//  LocationWeatherViewController.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 18.09.2022.
//

import Foundation
import UIKit

class LocationWeatherViewController: UIViewController {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<LocationWeatherViewModel.Section, LocationWeatherViewModel.Item>
    typealias SnapshotType = NSDiffableDataSourceSnapshot<LocationWeatherViewModel.Section, LocationWeatherViewModel.Item>
    
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    let viewModel: LocationWeatherViewModel
    var dataSource: DataSourceType!
    
    var weatherView: LocationWeatherView! {
        guard isViewLoaded else { return nil }
        return (view as! LocationWeatherView)
    }
    
    var collectionView: UICollectionView {
        return weatherView.collectionView
    }
    
    init(viewModel: LocationWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let weatherView = LocationWeatherView()
        self.view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureForecastCollectionView()
        setupBindings()
    }

    func setupBindings() {
        viewModel.currentWeatherViewModel.bind { [weak self] currentWeatherViewModel in
            guard let currentWeatherViewModel else { return }
            self?.weatherView.configure(with: currentWeatherViewModel)
        }
        viewModel.forecastCellViewModelsBySection.bind { [weak self] cellViewModelsBySection in
            self?.applySnapshot(with: cellViewModelsBySection)
        }
    }
    
    func configureForecastCollectionView() {
        collectionView.register(HourlyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.reuseIdentifier)
        collectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier)
        collectionView.collectionViewLayout = collectionViewLayout()
        collectionView.dataSource = dataSource
        dataSource = collectionViewDataSource()
    }
}

extension LocationWeatherViewController {
    func collectionViewLayout() -> UICollectionViewCompositionalLayout {
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
    
    func collectionViewDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
                case .hourly(let hourlyCellViewModel):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! HourlyWeatherCollectionViewCell
                    cell.configure(with: hourlyCellViewModel)
                    return cell
                case .daily(let dailyCellViewModel):
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyWeatherCollectionViewCell.reuseIdentifier, for: indexPath) as! DailyWeatherCollectionViewCell
                cell.configure(with: dailyCellViewModel)
                    return cell
            }
        })
        return dataSource
    }
    
    func applySnapshot(with cellViewModelsBySection: [LocationWeatherViewModel.Section: [ForecastCellViewModel]]) {
        var snapshot = SnapshotType()
        for section in LocationWeatherViewModel.Section.allCases {
            snapshot.appendSections([section])
            let viewModels = cellViewModelsBySection[section, default: []]
            var items = [LocationWeatherViewModel.Item]()
            switch section {
                case .hourly:
                    items = viewModels.map { LocationWeatherViewModel.Item.hourly($0 as! HourlyForecastCellViewModel) }
                case .daily:
                    items = viewModels.map { LocationWeatherViewModel.Item.daily($0 as! DailyForecastCellViewModel) }
            }
            snapshot.appendItems(items, toSection: section)
        }
        dataSource.apply(snapshot)
    }
}
