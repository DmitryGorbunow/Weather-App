//
//  AlertManager.swift
//  Interval Running
//
//  Created by Dmitry Gorbunow on 8/29/23.
//

import UIKit

final class AlertManager {
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

// MARK: - Show Validation Alerts
extension AlertManager {
    public static func showInvalidCityAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Некорректное имя города", message: "Проверьте корректность ввода")
    }
}

