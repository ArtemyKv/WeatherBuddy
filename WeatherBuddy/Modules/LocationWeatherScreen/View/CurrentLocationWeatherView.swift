//
//  CurrentLocationWeatherView.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 03.10.2022.
//

import Foundation
import UIKit

final class CurrentLocationWeatherView: UIView {
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    let areaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 80, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .left
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let promptLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .ultraLight)
        label.textAlignment = .center
        label.text = "Tap to see details"
        return label
    }()
    
    private let backgroundView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .regular)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let innerVStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 8
        return vStack
    }()
    
    private let middleHStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .fill
        hStack.spacing = 8
        return hStack
    }()
    
    private let outerVStack: UIStackView = {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 8
        return vStack
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
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
        innerVStack.addArrangedSubview(temperatureLabel)
        innerVStack.addArrangedSubview(descriptionLabel)
  
        middleHStack.addArrangedSubview(imageView)
        middleHStack.addArrangedSubview(innerVStack)
        
        outerVStack.addArrangedSubview(cityLabel)
        outerVStack.addArrangedSubview(areaLabel)
        outerVStack.addArrangedSubview(middleHStack)
        outerVStack.addArrangedSubview(dateLabel)
        outerVStack.addArrangedSubview(promptLabel)
        
        self.addSubview(backgroundView)
        self.addSubview(outerVStack)
    }
    
    func setupConstraints() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: middleHStack.widthAnchor, multiplier: 0.4).isActive = true
        
        outerVStack.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            outerVStack.leadingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.leadingAnchor, constant: 8),
            outerVStack.trailingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.trailingAnchor, constant: -8),
            outerVStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            outerVStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
        ])
    }
    
    func configure(with viewModel: LocationViewModel) {
        cityLabel.text = viewModel.cityName
        areaLabel.text = viewModel.areaName
        dateLabel.text = viewModel.date
    }
    
    func configure(with viewModel: CurrentWeatherViewModel) {
        temperatureLabel.text = viewModel.temperature
        descriptionLabel.text = viewModel.weatherDescription
        imageView.image = viewModel.weatherIcon
    }
}
