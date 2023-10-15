//
//  Validator.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/11/23.
//

import Foundation

final class Validator {
    static func isValidCity(for city: String) -> Bool {
        let city = city.trimmingCharacters(in: .whitespacesAndNewlines)
        let cityRegEx = #"^[^\W\d_]+\.?(?:[-\s'’][^\W\d_]+\.?)*$"#
        let cityPred = NSPredicate(format: "SELF MATCHES %@", cityRegEx)
        return cityPred.evaluate(with: city)
    }
}
