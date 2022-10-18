//
//  UIColorExtension.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 04.10.2022.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(rgb: UInt32, alpha: CGFloat = 1.0) {
        let red = (rgb & 0xFF0000) >> 16
        let green = (rgb & 0x00FF00) >> 8
        let blue = (rgb & 0x0000FF)
        
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
    }
}

extension UIColor {
    static let clearDay = UIColor(rgb: 0x12ddfc)
    static let clearNight = UIColor(rgb: 0x528FF5)
//    static let partlyCloudyDay = UIColor(rgb: )
//    static let partlyCloudyNight = UIColor(rgb: )
    static let cloudyDay = UIColor(rgb: 0xC0C0C0)
    static let cloudyNight = UIColor(rgb: 0x808080)
    static let precipitationDay = UIColor(rgb: 0x99bbcc)
    static let precipitationNight = UIColor(rgb: 0x556699)
    static let fogDay = UIColor(rgb: 0xff34e1)
    static let fogNight = UIColor(rgb: 0x556655)
    static let storm = UIColor(rgb: 0x660066)
    

}

extension UIColor {
    static func weatherColor(forIconID iconID: String) -> UIColor {
        switch iconID {
            case "01d", "02d":
                return UIColor.clearDay
            case "01n", "02n":
                return UIColor.clearNight
            case "03d", "04d":
                return UIColor.cloudyDay
            case "03n", "04n":
                return UIColor.cloudyNight
            case "09d", "10d", "13d":
                return UIColor.precipitationDay
            case "09n", "10n", "13n":
                return UIColor.precipitationNight
            case "50d":
                return UIColor.fogDay
            case "50n":
                return UIColor.fogNight
            case "11d", "11n":
                return UIColor.storm
            default:
                return UIColor.systemBackground
        }
    }
}
