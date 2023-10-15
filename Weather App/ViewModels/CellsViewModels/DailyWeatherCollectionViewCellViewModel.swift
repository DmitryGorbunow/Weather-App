//
//  DailyWeatherCollectionViewCellViewModel.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/2/23.
//

import Foundation

protocol IDailyWeatherCollectionViewCellViewModel {
    var temperature: String { get }
    var date: String{ get }
    init(model: DaytimeWeather)
}

struct DailyWeatherCollectionViewCellViewModel: IDailyWeatherCollectionViewCellViewModel {
    
    // MARK: - Properties
    private let model: DaytimeWeather
    
    var temperature: String {
        return "мин. " + String(format: "%.0f", (model.minTemp)) + "°" + "  макс. " + String(format: "%.0f", (model.maxTemp)) + "°"
    }
    
    var date: String {
       return getData()
    }
    
    // MARK: - init
    init(model: DaytimeWeather) {
        self.model = model
    }
    
    // MARK: - Private Methods
    private func getData() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: model.date)
    }
}
