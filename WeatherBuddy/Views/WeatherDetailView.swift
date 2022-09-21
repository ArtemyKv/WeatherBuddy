//
//  CurrentWeatherView.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 17.09.2022.
//

import Foundation
import UIKit

class WeatherDetailView: UIView {
    let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let areaLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
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
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        return collectionView
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
        //Sample background color
        backgroundColor = .systemOrange
        
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
        
        //Adding outer stack and collection view to superview
        backgroundView.contentView.addSubview(outerVStack)
        self.addSubview(backgroundView)
        outerVStack.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            outerVStack.leadingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.leadingAnchor, constant: 8),
            outerVStack.trailingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.trailingAnchor, constant: -8),
            outerVStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            outerVStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            backgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            backgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            collectionView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 40),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
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
