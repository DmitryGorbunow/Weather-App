//
//  ThreeHourWeather.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/6/23.
//

import Foundation

struct ThreeHourWeather: Codable {
    let list: [List]
}

struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}

struct Weather: Codable {
    let description: String
    let icon: String
}



