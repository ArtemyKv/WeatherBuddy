//
//  HoulyWeatherCollectionViewCell.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 21.09.2022.
//

import UIKit

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HourlyWeatherCollectionViewCell"
    
    let hourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        vStack.addArrangedSubview(hourLabel)
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(temperatureLabel)
        contentView.addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vStack.topAnchor.constraint(equalTo: self.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: HourlyForecastCellViewModel) {
        hourLabel.text = viewModel.hour
        temperatureLabel.text = viewModel.temperature
        imageView.image = viewModel.weatherIcon
    }
}
