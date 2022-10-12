//
//  Location+CoreDataProperties.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 07.10.2022.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var name: String?
    @NSManaged public var country: String?
    @NSManaged public var administrativeArea: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timezoneData: Data?
    @NSManaged public var order: Int32

}

extension Location : Identifiable {

}
