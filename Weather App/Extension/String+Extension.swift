//
//  String+Extension.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/9/23.
//

import UIKit
extension String {
    var encodeUrl : String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var decodeUrl : String {
        return self.removingPercentEncoding!
    }
}
