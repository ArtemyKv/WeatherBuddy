//
//  DailyWeatherCollectionViewCell.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 22.09.2022.
//

import UIKit

class DailyWeatherCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DailyWeatherCollectionViewCell"
    
    let weekdayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    let minTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let maxTempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17 , weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
       addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        hStack.addArrangedSubview(weekdayLabel)
        hStack.addArrangedSubview(imageView)
        hStack.addArrangedSubview(minTempLabel)
        hStack.addArrangedSubview(maxTempLabel)
        contentView.addSubview(hStack)
    }
    
    private func setupConstraints() {
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            minTempLabel.widthAnchor.constraint(equalToConstant: 35),
            maxTempLabel.widthAnchor.constraint(equalTo: minTempLabel.widthAnchor),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            hStack.topAnchor.constraint(equalTo: self.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: DailyForecastCellViewModel) {
        weekdayLabel.text = viewModel.weekDayString
        minTempLabel.text = viewModel.minTemperature
        maxTempLabel.text = viewModel.maxTemperature
        imageView.image = viewModel.weatherIcon
    }
}
