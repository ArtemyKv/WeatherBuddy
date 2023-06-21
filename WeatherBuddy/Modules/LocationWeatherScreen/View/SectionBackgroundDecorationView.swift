//
//  SectionBackgroundDecorationView.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 21.09.2022.
//

import Foundation
import UIKit

final class SectionBackgroundDecorationView: UICollectionReusableView {
    
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: .regular)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private func setupView() {
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
