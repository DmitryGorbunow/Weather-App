//
//  DataManager.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/13/23.
//

import Foundation

final class DataManager {
    
    // MARK: - Properties
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults()
    
    // MARK: - init
    private init() {}
    
    // MARK: - Public Methods
    func setCity(key: String, name: String?) {
        userDefaults.set(name, forKey: key)
    }
    
    func getCity(key: String) -> String? {
        userDefaults.string(forKey: key)
    }
}
