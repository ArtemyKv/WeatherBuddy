//
//  Coordinator.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 25.06.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
    func childDidFinish(_ coordinator: Coordinator)
}

extension Coordinator {
    func childDidFinish(_ coordinator: Coordinator) {
        for (index, child) in children.enumerated() {
            guard child === coordinator else { continue }
            children.remove(at: index)
        }
    }
}
