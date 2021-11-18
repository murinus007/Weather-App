//
//  WeatherService.swift
//  Weather App
//
//  Created by Alexey Sergeev on 26.10.2021.
//

import Foundation
import CoreLocation

final class WeatherServiceImpl {
    let APIKey = "77202e8115d0296ee4a9e5e1f8f215d4"
    
    func getCurrentLocationWeather(location: CLLocation?, completion: @escaping (Weather) -> Void) {
        guard let location = location
        else {
            return
        }
        
        let long = location.coordinate.longitude
        let lat = location.coordinate.latitude
        let URLString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=metric&appid=\(APIKey)"
        let task = URLSession.shared
            .dataTask(with: URL(string: URLString)!, completionHandler:
        { data, _, error in
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data!)
                DispatchQueue.main.async {
                    completion(weather)
                }
            } catch {
                print(error)
            }
        })
        
        task.resume()
    }
}
