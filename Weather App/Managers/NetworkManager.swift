//
//  APIManager.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/1/23.
//

import Foundation
import CoreLocation

class NetworkManager {    
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, Error?) -> Void
    typealias ForecastWeatherCompletionHandler = (ThreeHourWeather?, Error?) -> Void
    
    // MARK: - Properties
    private let apiKey = "1e51dbb8ec3c34a1b9f37ad7eaeb9607"
    private let decoder = JSONDecoder()
    private let session: URLSession
    
    private enum SuffixURL: String {
        case forecastWeather = "forecast"
        case currentWeather = "weather"
    }
    
    // MARK: - init
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    // MARK: - Private Methods
    private func baseUrl(_ suffixURL: SuffixURL, cityName: String = "", coordinates: String = "") -> URL {
        
        let urlString = "https://api.openweathermap.org/data/2.5/\(suffixURL.rawValue)?\(cityName)\(coordinates)appid=\(self.apiKey)&lang=ru&units=metric"
        
        let url = URL(string: urlString.encodeUrl)!
        
        return url
    }

    private func getBaseRequest<T: Codable>(cityName: String = "",
                                            coordinates: CLLocationCoordinate2D? = nil,
                                            suffixURL: SuffixURL,
                                            completionHandler completion:  @escaping (_ object: T?,_ error: Error?) -> ()) {
        var url: URL
        if let coordinates = coordinates {
            let coordinatesString = "lat=\(String(describing: coordinates.latitude))&lon=\(String(describing: coordinates.longitude))&"
            url = baseUrl(suffixURL, coordinates: coordinatesString)
        } else {
            let cityNameString = "q=\(cityName)&"
            url = baseUrl(suffixURL, cityName: cityNameString)
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, ResponseError.requestFailed)
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        do {
                            let weather = try self.decoder.decode(T.self, from: data)
                            completion(weather, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, ResponseError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    // MARK: - Public Methods
    func getCurrentWeather(cityName: String = "", coordinates: CLLocationCoordinate2D? = nil, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        
        if coordinates == nil {
            getBaseRequest(cityName: cityName, suffixURL: .currentWeather) { (weather: CurrentWeather?, error) in
                completion(weather, error)
            }
        } else {
            getBaseRequest(coordinates: coordinates, suffixURL: .currentWeather) { (weather: CurrentWeather?, error) in
                completion(weather, error)
            }
        }
        
    }
    
    func getForecastWeather(cityName: String = "", coordinates: CLLocationCoordinate2D? = nil, completionHandler completion: @escaping ForecastWeatherCompletionHandler) {
        
        if coordinates == nil {
            getBaseRequest(cityName: cityName, suffixURL: .forecastWeather) { (weather: ThreeHourWeather?, error) in
                completion(weather, error)
            }
        } else {
            getBaseRequest(coordinates: coordinates, suffixURL: .forecastWeather) { (weather: ThreeHourWeather?, error) in
                completion(weather, error)
            }
        }
    }
}

