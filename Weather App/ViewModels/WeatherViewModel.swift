//
//  CurrentWeatherViewModel.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/2/23.
//

import Foundation

protocol IWeatherViewModel {
    var currentWeather: Bindable<CurrentWeather> { get  set }
    var threeHourWeather: Bindable<ThreeHourWeather> { get set }
    var isSearching: Bindable<Bool> { get set }
    func getWeather()
    func currentWeatherCellViewModel() -> CurrentWeatherCollectionViewCellViewModel?
    func hourlyWeatherCellViewModel(at indexPath: IndexPath) -> HourlyWeatherCollectionViewCellViewModel?
    func dailyWeatherCellViewModel(at indexPath: IndexPath) -> DailyWeatherCollectionViewCellViewModel?
    func clearData()
}

final class WeatherViewModel: IWeatherViewModel {
    // MARK: - Properties
    private let networkManager = NetworkManager()
    var currentWeather = Bindable<CurrentWeather>()
    var threeHourWeather = Bindable<ThreeHourWeather>()
    var isSearching = Bindable<Bool>()
    
    private var city: String? {
        DataManager.shared.getCity(key: .cityKey)
    }
    
    // MARK: - Private Methods
    private func getWeatherForCity(cityName: String) {
        networkManager.getCurrentWeather(cityName: cityName) { weather, error in
            guard let weather = weather else { return}
            self.currentWeather.value = weather
        }
        
        networkManager.getForecastWeather(cityName: cityName) { weather, error in
            guard let weather = weather else { return}
            self.threeHourWeather.value = weather
            self.isSearching.value = false
        }
    }
    
    private func getWeatherForLocation() {
        LocationManager.shared.getCurrenLocation { [weak self] location in
            self?.networkManager.getCurrentWeather(coordinates: location.coordinate) { weather, error in
                guard let weather = weather else { return}
                self?.currentWeather.value = weather
            }
            
            self?.networkManager.getForecastWeather(coordinates: location.coordinate) { weather, error in
                guard let weather = weather else { return}
                self?.threeHourWeather.value = weather
                self?.isSearching.value = false
            }
        }
    }
    
    /*
     openweathermap.org provides only a forecast for every three hours for free. In order to get a forecast for the next four days, the data transformation is performed in the method below.
     */
    private func convertThreeHourToDailyWeather() -> [DaytimeWeather]? {
        guard let list = threeHourWeather.value?.list else { return nil }
        var dayTimeWeather = [DaytimeWeather]()
        let date = NSDate(timeIntervalSince1970: TimeInterval(list.first?.dt ?? 0)) as Date
        var firstElement = date.get(.day)
        var temporaryArray = [Double]()
        for i in list {
            let date = NSDate(timeIntervalSince1970: TimeInterval(i.dt)) as Date
            if date.get(.day) == firstElement + 1 {
                temporaryArray.append(i.main.temp)
            }
            if temporaryArray.count == 8 {
                dayTimeWeather.append(DaytimeWeather(date: date, minTemp: temporaryArray.min() ?? 0, maxTemp: temporaryArray.max() ?? 0))
                temporaryArray.removeAll()
                firstElement += 1
            }
        }
        return dayTimeWeather
    }
    
    // MARK: - Public Methods
    func getWeather() {
        isSearching.value = true
        if let city = self.city {
            getWeatherForCity(cityName: city)
        } else {
            getWeatherForLocation()
        }
    }
    
    func currentWeatherCellViewModel() -> CurrentWeatherCollectionViewCellViewModel? {
        guard let currentWeather = currentWeather.value else { return nil }
        return CurrentWeatherCollectionViewCellViewModel(model: currentWeather)
    }
    
    func hourlyWeatherCellViewModel(at indexPath: IndexPath) -> HourlyWeatherCollectionViewCellViewModel? {
        guard let threeHourWeather = threeHourWeather.value else { return nil }
        return HourlyWeatherCollectionViewCellViewModel(model: threeHourWeather.list[indexPath.row])
    }
    
    func dailyWeatherCellViewModel(at indexPath: IndexPath) -> DailyWeatherCollectionViewCellViewModel? {
        guard let dailyWeather = convertThreeHourToDailyWeather() else { return nil }
        return DailyWeatherCollectionViewCellViewModel(model: dailyWeather[indexPath.row])
    }
    
    func clearData() {
        currentWeather.value = nil
        threeHourWeather.value = nil
    }
}
