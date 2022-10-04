//
//  CurrentWeatherView.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 03.10.2022.
//

import Foundation
import UIKit

class CurrentWeatherView: UIView {
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
    
    private func setupView() {
        //Adding view to inner stack
        innerVStack.addArrangedSubview(temperatureLabel)
        innerVStack.addArrangedSubview(descriptionLabel)
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        //Adding view to middle stack
        middleHStack.addArrangedSubview(imageView)
        middleHStack.addArrangedSubview(innerVStack)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: middleHStack.widthAnchor, multiplier: 0.4).isActive = true
        
        //Adding view to outer stack
        outerVStack.addArrangedSubview(cityLabel)
        outerVStack.addArrangedSubview(areaLabel)
        outerVStack.addArrangedSubview(middleHStack)
        outerVStack.addArrangedSubview(dateLabel)
        
        self.addSubview(outerVStack)
        outerVStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            outerVStack.topAnchor.constraint(equalTo: self.topAnchor),
            outerVStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            outerVStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            outerVStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
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
