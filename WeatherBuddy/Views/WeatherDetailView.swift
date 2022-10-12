//
//  CurrentWeatherView.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 17.09.2022.
//

import Foundation
import UIKit

class WeatherDetailView: UIView {
    
    var currentWeatherIsVisible: Bool = true {
        didSet {
            currentWeatherView.isHidden = !currentWeatherIsVisible
            weatherParametersView.isHidden = currentWeatherIsVisible
        }
    }
    
    let currentWeatherView = CurrentWeatherView()
    let weatherParametersView = WeatherParametersView()
    
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
    
    private func setupView() {
        //Sample background color
        backgroundColor = .systemOrange
        
        //Adding outer stack and collection view to superview
        backgroundView.contentView.addSubview(currentWeatherView)
        backgroundView.contentView.addSubview(weatherParametersView)
        
        currentWeatherIsVisible = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(flipViews))
        backgroundView.addGestureRecognizer(tapRecognizer)
        
        self.addSubview(backgroundView)
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        weatherParametersView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentWeatherView.leadingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.leadingAnchor, constant: 8),
            currentWeatherView.trailingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.trailingAnchor, constant: -8),
            currentWeatherView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            currentWeatherView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),
            weatherParametersView.leadingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.leadingAnchor, constant: 8),
            weatherParametersView.trailingAnchor.constraint(equalTo: backgroundView.layoutMarginsGuide.trailingAnchor, constant: -8),
            weatherParametersView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 20),
            weatherParametersView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -20),

            backgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            backgroundView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 32),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -40),
            collectionView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
        ])
        
    }
    
    @objc func flipViews() {
        UIView.transition(from: currentWeatherIsVisible ? currentWeatherView : weatherParametersView,
                          to: currentWeatherIsVisible ? weatherParametersView : currentWeatherView,
                          duration: 0.5,
                          options: [.transitionFlipFromLeft, .showHideTransitionViews])
        
        currentWeatherIsVisible.toggle()
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
