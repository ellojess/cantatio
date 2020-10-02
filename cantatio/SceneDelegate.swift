//
//  SceneDelegate.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/11/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate,
                     SPTAppRemoteDelegate {
    
    static private let kAccessTokenKey = "access-token-key"
    
    var window: UIWindow?
    
    var navigationController: UINavigationController?
    
    let vc = AuthVC() //needed to not use storyboard
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds) //needed to not use storyboard
        
        navigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigationController //needed to not use storyboard
        window?.makeKeyAndVisible() //needed to not use storyboard
        window?.windowScene = windowScene //needed to not use storyboard
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let url = URLContexts.first?.url else { return }
        let parameters = vc.appRemote.authorizationParameters(from: url)
        if let code = parameters?["code"] {
            vc.authCode = code
        } else if let _ = parameters?[SPTAppRemoteAccessTokenKey] {
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            print("No access token error =", error_description)
        }
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        connect();
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        vc.appRemote.disconnect()
    }
    
    func connect() {
        vc.appRemote.connect()
    }
    
    // MARK: AppRemoteDelegate
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        vc.appRemote = appRemote
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("didFailConnectionAttemptWithError")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("didDisconnectWithError")
    }
    
    
}
