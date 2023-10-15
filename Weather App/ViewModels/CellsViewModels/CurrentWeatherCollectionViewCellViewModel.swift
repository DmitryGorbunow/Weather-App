//
//  CurrentWeatherCollectionViewCellViewModel.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/2/23.
//

import Foundation

protocol ICurrentWeatherCollectionViewCellViewModel {
    var temperature: String { get }
    var description: String { get }
    var cityName: String { get }
    init(model: CurrentWeather)
}

struct CurrentWeatherCollectionViewCellViewModel: ICurrentWeatherCollectionViewCellViewModel {
    
    // MARK: - Properties
    private let model: CurrentWeather
    
    var temperature: String {
        return String(format: "%.0f", (model.main.temp)) + "°"
    }
    
    var description: String {
        return model.weather.first?.description ?? ""
    }
    
    var cityName: String {
        return model.name
    }
    
    // MARK: - init
    init(model: CurrentWeather) {
        self.model = model
    }
}
