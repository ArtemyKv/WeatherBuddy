//
//  LocationsListTableViewCell.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 11.10.2022.
//

import UIKit

class LocationsListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "LocationsListTableViewCell"
    
    let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .lightGray
        return view
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .left
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .ultraLight)
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
        imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 270), for: .horizontal)
        return imageView
    }()
    
    let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
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
        stack.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        return stack
    }()
    
    override func layoutSubviews() {
        super .layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    func setupView() {
        vStack.addArrangedSubview(locationLabel)
        vStack.addArrangedSubview(conditionLabel)
        hStack.addArrangedSubview(vStack)
        hStack.addArrangedSubview(conditionImageView)
        hStack.addArrangedSubview(temperatureLabel)
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(hStack)
        self.contentView.layer.cornerRadius = 20
        
        NSLayoutConstraint.activate([
            temperatureLabel.widthAnchor.constraint(equalToConstant: 65),
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20)
        ])
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
