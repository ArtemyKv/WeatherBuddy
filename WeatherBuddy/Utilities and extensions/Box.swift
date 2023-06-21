//
//  Box.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 19.09.2022.
//

import Foundation

final class Box<T> {
    typealias Listener = (T) -> Void
    
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
