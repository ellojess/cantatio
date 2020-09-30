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
    private let redirectUri = URL(string:"\(redirect)")!
    private let clientIdentifier = "\(ids)"

    var window: UIWindow?
    
    var navigationController: UINavigationController?

    lazy var appRemote: SPTAppRemote = {
        let configuration = SPTConfiguration(clientID: self.clientIdentifier, redirectURL: self.redirectUri)
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()

    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: SceneDelegate.kAccessTokenKey)
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds) //needed to not use storyboard
        let vc = AuthVC() //needed to not use storyboard
        navigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigationController //needed to not use storyboard
        window?.makeKeyAndVisible() //needed to not use storyboard
        window?.windowScene = windowScene //needed to not use storyboard
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let url = URLContexts.first?.url else {
            return
        }

        let urlString = url.absoluteString

        let urlArray = urlString.components(separatedBy: "code=")
        print(urlArray)
        
        spotifyCode = "\(urlArray[1])"
        
        let parameters = appRemote.authorizationParameters(from: url)

        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
        } else if let _ = parameters?[SPTAppRemoteErrorDescriptionKey] {
            // Show the error
        }

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        connect();
    }

    func sceneWillResignActive(_ scene: UIScene) {
        appRemote.disconnect()
    }

    func connect() {
        appRemote.connect()
    }

    // MARK: AppRemoteDelegate
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote = appRemote
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("didFailConnectionAttemptWithError")
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("didDisconnectWithError")
    }

    var playerViewController: AuthVC {
        get {
            let navController = self.window?.rootViewController?.children[0] as! UINavigationController
            return navController.topViewController as! AuthVC
        }
    }


}
