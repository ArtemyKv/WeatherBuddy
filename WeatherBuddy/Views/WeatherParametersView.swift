//
//  WeatherParametersView.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 03.10.2022.
//

import Foundation
import UIKit

class WeatherParametersView: UIView {
    
   private enum Title: String, CaseIterable {
        case feelsLike = "Feels Like"
        case pressure = "Pressure"
        case humidity = "Humidity"
        case visibility = "Visibility"
        case windSpeed = "Wind Speed"
        case windDirection = "Wind Direction"
    }
    
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    lazy var feelsLikeLabel = parameterLabel()
    lazy var pressureLabel = parameterLabel()
    lazy var humidityLabel = parameterLabel()
    lazy var visibilityLabel = parameterLabel()
    lazy var windSpeedLabel = parameterLabel()
    lazy var windDirectionLabel = parameterLabel()
    
    let windDirectionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let firstRowHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        return stack
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()
    
    private func parameterLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        return label
    }
    
    private func titleLabelWith(title: Title) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.text = title.rawValue
        label.textAlignment = .left
        label.setContentHuggingPriority(UILayoutPriority(249), for: .horizontal)
        return label
    }
    
    private func setupView() {
        let parameterLabels = [feelsLikeLabel, pressureLabel, humidityLabel, visibilityLabel, windSpeedLabel, windDirectionLabel]
        
        firstRowHStack.addArrangedSubview(cityLabel)
        firstRowHStack.addArrangedSubview(temperatureLabel)
        vStack.addArrangedSubview(firstRowHStack)
        
        for (index, title) in Title.allCases.enumerated() {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.distribution = .fill
            hStack.alignment = .fill
            hStack.spacing = 8
            
            let titleLabel = titleLabelWith(title: title)
            let parameterLabel = parameterLabels[index]
            hStack.addArrangedSubview(titleLabel)
            
            if title == .windDirection {
                hStack.addArrangedSubview(windDirectionImage)
            }
            
            hStack.addArrangedSubview(parameterLabel)
            vStack.addArrangedSubview(hStack)
        }
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
