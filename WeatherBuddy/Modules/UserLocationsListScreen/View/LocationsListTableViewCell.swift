//
//  LocationsListTableViewCell.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 11.10.2022.
//

import UIKit

final class LocationsListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "LocationsListTableViewCell"
    
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
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super .layoutSubviews()
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8))
    }
    
    private func setupView() {
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
            temperatureLabel.widthAnchor.constraint(equalToConstant: 80),
            hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func animateSelection(completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.curveEaseIn],
            animations: {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.transform = .identity
                }
                completion()
            })
    }
}
