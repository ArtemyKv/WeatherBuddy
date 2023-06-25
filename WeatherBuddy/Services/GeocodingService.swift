//
//  GeocodingService.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 16.09.2022.
//

import Foundation
import CoreLocation
import CoreData

final class GeocodingService {
    private let geocoder = CLGeocoder()
    
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func getLocation(from adressString: String, completion: @escaping (Location) -> Void) {
        geocoder.geocodeAddressString(adressString) { placemarks, error in
            self.geocodingCompletion(isCurrentLocation: false, placemarks: placemarks, error: error, completion: completion)
        }
    }
    
    func getLocationFrom(latitude: Double, longitude: Double, completion: @escaping (Location) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            self.geocodingCompletion(isCurrentLocation: true, placemarks: placemarks, error: error, completion: completion)
        }
    }
    
    private func geocodingCompletion(isCurrentLocation: Bool, placemarks: [CLPlacemark]?, error: Error?, completion: @escaping (Location) -> Void) {
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
        let location = Location(context: isCurrentLocation ? coreDataStack.childContext : coreDataStack.managedContext)
        location.name = placemark.locality
        location.country = placemark.country
        location.administrativeArea = placemark.administrativeArea
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.timeZone = placemark.timeZone ?? TimeZone.current
        completion(location)
    }
}
