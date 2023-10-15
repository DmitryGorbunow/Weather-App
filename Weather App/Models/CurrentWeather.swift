//
//  CurrentWeather.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/1/23.
//

import Foundation

struct CurrentWeather: Codable {
    let main: Main
    let name: String
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double    
}
