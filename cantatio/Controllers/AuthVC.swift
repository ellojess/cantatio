//
//  ViewController.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/11/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import UIKit

class AuthVC: UIViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    // MARK: Variables
    private let SpotifyClientID = "\(clientId)"
    private let SpotifyRedirectURI = URL(string: "\(redirect)")!
    
    var authCode = "" {
        didSet {
            fetchAccessToken()
        }
    }
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let configuration = SPTConfiguration(clientID: clientId, redirectURL: URL.init(string: redirect)!)
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        
        let requestedScopes: SPTScope = [.appRemoteControl, .userTopRead]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
        
        appRemote.connectionParameters.accessToken = NetworkManager.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    private var lastPlayerState: SPTAppRemotePlayerState?
    
    
    // MARK: - UI
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login with Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNextCondensed-DemiBold", size: 20)
        button.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.0)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        view.addSubview(stackView)
        stackView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8).isActive = true
        stackView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.13).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.view.backgroundColor = .systemPink
        
        stackView.addArrangedSubview(loginButton)
        
        loginButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @objc func loginButtonTapped(){
        print("login button pressed")
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            sessionManager.initiateSession(with: scope, options: .clientOnly)
        } else {
            // Use this on iOS versions < 11 to use SFSafariViewController
            sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
        }
        
        //        let nextVC: TabbarController = TabbarController()
        //        nextVC.selectedIndex = 1
        //        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - SPTSessionManagerDelegate
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Failed to Connect")
    }
    
    // MARK: - SPTAppRemoteDelegate
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        //        updateViewBasedOnConnected()
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        fetchPlayerState()
    }
    
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        //        updateViewBasedOnConnected()
        lastPlayerState = nil
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        //        updateViewBasedOnConnected()
        lastPlayerState = nil
    }
    
    // MARK: - SPTAppRemotePlayerAPIDelegate
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }
    
    // Fetch Access Token
    
    func fetchAccessToken() {
        NetworkManager.fetchAccessToken(authCode: authCode) { (error) in
            if let error = error {
                print(error)
                return
            }
            print("success, got \(NetworkManager.accessToken)")
            
            DispatchQueue.main.async {
                let nextVC: TabbarController = TabbarController()
                nextVC.selectedIndex = 1
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
        }
    }
    
    // MARK: - Image API
    private func fetchAlbumArtForTrack(_ track: SPTAppRemoteTrack, callback: @escaping (UIImage) -> Void ) {
        appRemote.imageAPI?.fetchImage(forItem: track, with:CGSize(width: 1000, height: 1000), callback: { (image, error) -> Void in
            guard error == nil else { return }
            
            let image = image as! UIImage
            callback(image)
        })
    }
    
    
    // MARK: - Private Helpers
    
    private func presentAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true)
        }
    }
    
    
    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            //            fetchArtwork(for: playerState.track)
            print("working")
        }
        lastPlayerState = playerState
    }
    
    func fetchPlayerState() {
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            }
        })
    }
    
}

