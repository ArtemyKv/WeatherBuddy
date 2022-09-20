//
//  GeocodingService.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 16.09.2022.
//

import Foundation
import CoreLocation

class GeocodingService {
    private let geocoder = CLGeocoder()
    
    func getLocation(from adressString: String, completion: @escaping (Location) -> Void) {
        geocoder.geocodeAddressString(adressString) { placemarks, error in
            guard error == nil else {
                print("Error getting location")
                return
            }
            guard let placemarks = placemarks,
                  let placemark = placemarks.first,
                  let coordinate = placemark.location?.coordinate
            else {
                print("No such location")
                return
            }
            
            let location = Location(name: placemark.locality,
                                    country: placemark.country,
                                    administrativeArea: placemark.administrativeArea,
                                    latitude: coordinate.latitude,
                                    longitude: coordinate.longitude)
            completion(location)
        }
    }
    
    func getLocationFrom(latitude: Double, longitude: Double, completion: @escaping (Location) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Error getting location")
                return
            }
            guard let placemarks = placemarks,
                  let placemark = placemarks.first,
                  let coordinate = placemark.location?.coordinate
            else {
                print("No such location")
                return
            }
            let location = Location(name: placemark.locality,
                                    country: placemark.country,
                                    administrativeArea: placemark.administrativeArea,
                                    latitude: coordinate.latitude,
                                    longitude: coordinate.longitude)
            completion(location)
        }
    }
}
