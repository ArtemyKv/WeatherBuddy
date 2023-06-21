//
//  WeatherFetchingService.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 15.09.2022.
//

import Foundation

enum WeatherFetchingError: Error {
    case failedRequest
    case invalidResponse
    case noData
    case invalidData
}

final class WeatherFetchingService {
    
    private let apiKey = "42abe6b8696e0ab3543581a5d840e8f4"
    private let scheme = "https"
    private let host = "api.openweathermap.org"
    private let path = "/data/2.5"
    
    private let session = URLSession(configuration: .default)
    
    private enum WeatherInfoType {
        static let currentWeather = "weather"
        static let forecast = "forecast"
    }
    
    private func fetchWeatherData<T: Codable>(
        weatherInfoType: String,
        location: Location,
        completion: @escaping (T?, WeatherFetchingError?) -> Void
    ) {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + "/" + weatherInfoType
        components.queryItems = [
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "lon", value: "\(location.longitude)"),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        let url = components.url!
        
        let sessionTask = session.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from server: \(error!), \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Unable to process response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    print("Failure response with code: \(httpResponse.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returnned from server")
                    completion(nil, .noData)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(T.self, from: data)
                    completion(results, nil)
                } catch let error {
                    print("Failed decoding data with error: \(error), \(error.localizedDescription)")
                    completion(nil, .invalidData)
                    return
                }
            }
        }
        sessionTask.resume()
    }
    
    func fetchCurrentWeatherData(for location: Location, completion: @escaping (Weather?, WeatherFetchingError?) -> Void ) {
        fetchWeatherData(weatherInfoType: WeatherInfoType.currentWeather, location: location, completion: completion)
    }
    
    func fetchForecastWeatherData(for location: Location, completion: @escaping (ForecastResponse?, WeatherFetchingError?) -> Void ) {
        fetchWeatherData(weatherInfoType: WeatherInfoType.forecast, location: location, completion: completion)
    }
}
