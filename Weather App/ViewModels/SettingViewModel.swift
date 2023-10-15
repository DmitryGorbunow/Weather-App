//
//  SettingViewModel.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/14/23.
//

import Foundation

protocol ISettingViewModel {
    var canDismiss: Bool { get set }
    func okButtonTapped()
    func setCity(name: String?)
    func changeDetectionMethod(value: Bool)
}

final class SettingViewModel: ISettingViewModel {
    // MARK: - Properties
    var canDismiss: Bool = true
    private var isDeterminationByLocation: Bool = true
    private var city: String? {
        DataManager.shared.getCity(key: .cityKey)
    }
    
    // MARK: - Public Methods
    func okButtonTapped() {
        if isDeterminationByLocation {
            canDismiss = true
        } else {
            if Validator.isValidCity(for: city ?? "") {
                canDismiss = true
            } else {
                canDismiss = false
            }
        }
    }
    
    func setCity(name: String?) {
        if name == "" {
            DataManager.shared.setCity(key: .cityKey, name: nil)
        } else {
            DataManager.shared.setCity(key: .cityKey, name: name)
        }
    }
    
    func changeDetectionMethod(value: Bool) {
        isDeterminationByLocation = value
    }
}
