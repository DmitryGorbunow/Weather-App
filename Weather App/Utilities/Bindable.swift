//
//  Bindable.swift
//  My
//
//  Created by Dmitry Gorbunow on 10/4/23.
//

import Foundation

final class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}
