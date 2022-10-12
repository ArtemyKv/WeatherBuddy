//
//  Location+CoreDataClass.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 06.10.2022.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {

}

extension Location {
    var timeZone: TimeZone {
        get {
            unarchiveJSON(data: timezoneData) ?? TimeZone.current
        }
        set {
            archiveJSON(value: newValue)
        }
    }
    
    private func archiveJSON<T: Encodable>(value: T) {
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(value) {
            self.timezoneData = data
        }
    }
    
    private func unarchiveJSON<T: Decodable>(data: Data?) -> T? {
        let jsonDecoder = JSONDecoder()
        guard let data = data else { return nil }
        return try! jsonDecoder.decode(T.self, from: data)
    }
}
