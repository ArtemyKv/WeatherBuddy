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
    
    private let containerView = UIView()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private func setupView() {
        //Sample background color
        backgroundColor = .systemOrange
        
        //Adding outer stack and collection view to superview
        containerView.addSubview(currentWeatherView)
        containerView.addSubview(weatherParametersView)
        
        currentWeatherIsVisible = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(flipViews))
        containerView.addGestureRecognizer(tapRecognizer)
        
        self.addSubview(containerView)
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        weatherParametersView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentWeatherView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            currentWeatherView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            currentWeatherView.topAnchor.constraint(equalTo: containerView.topAnchor),
            currentWeatherView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            weatherParametersView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            weatherParametersView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            weatherParametersView.topAnchor.constraint(equalTo: containerView.topAnchor),
            weatherParametersView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            containerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 32),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,constant: -40),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
    }
    
    @objc func flipViews() {
        let transitionDirection: UIView.AnimationOptions = currentWeatherIsVisible ? .transitionFlipFromTop : .transitionFlipFromBottom
        
        UIView.transition(from: currentWeatherIsVisible ? currentWeatherView : weatherParametersView,
                          to: currentWeatherIsVisible ? weatherParametersView : currentWeatherView,
                          duration: 0.5,
                          options: [transitionDirection, .showHideTransitionViews])
        
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
