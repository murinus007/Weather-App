//
//  weather.swift
//  Weather App
//
//  Created by Alexey Sergeev on 28.10.2021.
//

import Foundation

struct Weather: Codable {
    let name: String
    let main: Main
    let weather: [WeatherElement]
    let sys: Sys?
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
        }
}

struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

struct Sys: Codable {
    let id: Int
    let country: String
    let sunrise, sunset: Double
}
