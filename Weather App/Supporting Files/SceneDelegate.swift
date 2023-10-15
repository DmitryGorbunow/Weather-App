//
//  SceneDelegate.swift
//  Weather App
//
//  Created by Dmitry Gorbunow on 10/1/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let vc = WeatherViewController()
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
}

