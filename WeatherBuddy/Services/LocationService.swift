//
//  LocationService.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 19.09.2022.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func updateLocationWith(latitude: Double, longitude: Double)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    var delegate: LocationServiceDelegate?
    
    let locationManager = CLLocationManager()
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                print("Not determined")
                manager.requestWhenInUseAuthorization()
            case .restricted:
                //TODO: - Handle this case with some kind of message to user
                print("Restricted")
            case .denied:
                if CLLocationManager.locationServicesEnabled() {
                    //TODO: - Write instructions
                } else {
                    //TODO: - Write instructions
                }
                print("Denied")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorized")
                manager.requestLocation()
            default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationMark = locations.first else { return }
        delegate?.updateLocationWith(latitude: locationMark.coordinate.latitude, longitude: locationMark.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error), \(error.localizedDescription)")
    }
    
    override init() {
        super .init()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
    }
}
