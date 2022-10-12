//
//  LocationsListTableViewCell.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 11.10.2022.
//

import UIKit

class LocationsListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "LocationsListTableViewCell"
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .right
        return label
    }()
    
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    let conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    func setupView() {
        hStack.addArrangedSubview(locationLabel)
        hStack.addArrangedSubview(conditionImageView)
        hStack.addArrangedSubview(temperatureLabel)
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(conditionLabel)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configureCell(withViewModel viewModel: LocationsListCellViewModel) {
        self.locationLabel.text = viewModel.location
        self.conditionImageView.image = viewModel.image
        self.conditionLabel.text = viewModel.condition
        self.temperatureLabel.text = viewModel.temperature
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
