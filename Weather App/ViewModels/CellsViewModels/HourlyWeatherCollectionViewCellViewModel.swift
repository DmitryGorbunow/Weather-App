//
//  HourlyWeatherCollectionViewCellViewModel.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/2/23.
//

import Foundation

protocol IHourlyWeatherCollectionViewCellViewModel {
    var temperature: String { get }
    var time: String { get }
    var imageUrlString: String { get }
    init(model: List)
}

struct HourlyWeatherCollectionViewCellViewModel: IHourlyWeatherCollectionViewCellViewModel {
    
    // MARK: - Properties
    private let model: List
    
    var temperature: String {
        return String(format: "%.0f", (model.main.temp)) + "°"
    }
    
    var time: String {
        return unixTimeToCurrentTimeZone(unixTime: model.dt)
    }
    
    var imageUrlString: String {
        return "https://openweathermap.org/img/w/\(model.weather.first?.icon ?? "03d").png"
    }
    
    // MARK: - init
    init(model: List) {
        self.model = model
    }
    
    // MARK: - Private Methods
    private func unixTimeToCurrentTimeZone(unixTime: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(unixTime)) as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}
