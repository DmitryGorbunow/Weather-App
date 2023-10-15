//
//  ResponseError.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/7/23.
//

import Foundation

enum ResponseError: Error {
    case requestFailed
    case responseUnsuccessful(statusCode: Int)
    case invalidData
    case jsonParsingFailure
    case invalidURL
}
