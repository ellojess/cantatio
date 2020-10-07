//
//  NetworkManager.swift
//  cantatio
//
//  Created by Jessica Trinh on 10/1/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import Spartan

class NetworkManager {
    
    // MARK: - Variables
    public static let shared = NetworkManager()
    
    let urlSession = URLSession.shared
    
    static private let kAccessTokenKey = "access-token-key"
    
    static private let kRefreshTokenKey = "refresh-token-key"
    
    static private let authTokenKey = "auth-token-key"
    
    typealias JSONStandard = [String : AnyObject]
    var posts = [Track]()
    
    public static var authorizationToken: String?
    
    public static var loggingEnabled: Bool = true
    
    static let stringScopes = [
        "user-read-email", "user-read-private",
        "user-read-playback-state", "user-modify-playback-state", "user-read-currently-playing",
        "streaming", "app-remote-control",
        "user-library-modify", "user-library-read",
        "user-top-read", "user-read-playback-position", "user-read-recently-played",
        "user-follow-read", "user-follow-modify",
    ]
    
    static var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: NetworkManager.kAccessTokenKey)
        }
    }
    
    static var refreshToken = UserDefaults.standard.string(forKey: kRefreshTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(refreshToken, forKey: NetworkManager.kRefreshTokenKey)
        }
    }
    
    static var authCode = UserDefaults.standard.string(forKey: authTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(authCode, forKey: NetworkManager.authTokenKey)
        }
    }
    
    
    // Fetch Top 50 Artists
    static func fetchTopArtists(completion: @escaping (Result<[Artist], Error>) -> Void) {
        
        _ = Spartan.getMyTopArtists(limit: 50, offset: 0, timeRange: .mediumTerm, success: { (pagingObject) in
            completion(.success(pagingObject.items))
            
        }, failure: { (error) in
            completion(.failure(error))
        })
    }
    
    static func fetchNewReleases(){
        _ = Spartan.getNewReleases(country: .us, limit: 20, offset: 0, success: { (pagingObject) in
            if let items = pagingObject.items{
                items.forEach(){
                    print($0.name)
                }
            }
        }, failure: { (error) in
            print(error)
        })
    }
    
    
    static func getUser(){
        let url = URL(string: "https://api.spotify.com/v1/me/top/artists")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Spartan.authorizationToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {
                print("error", error ?? "Unknown error")
                return
            }
            
            if response.statusCode == 401 || response.statusCode == 403 {
                refreshAccessToken { (error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    print("success, got \(refreshToken)")
                    
                }
            }
        
            guard (200 ... 299) ~= response.statusCode else {
                print("status code  \(response.statusCode)")
                print("response = \(response)")
                return
            }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                print(jsonResult!)
            }
            catch let error as NSError {
                print(error.debugDescription)
            }
        }
        
        task.resume()
    }
    
    
    
    // Fetch Artist's Top Tracks
    static func fetchArtistTopTracks(artistId : String, completion: @escaping (Result<[Track], Error>) -> Void ){
        _ = Spartan.getArtistsTopTracks(artistId: artistId, country: .us, success: { (tracks) in
            completion(.success(tracks))
        }, failure: { (error) in
            completion(.failure(error))
        })
    }
    
    // Fetch accessToken from Spotify
    static func fetchAccessToken(authCode: String, completion: @escaping (_ error: String?) -> Void) {
        
        let url = URL(string: "\(baseURL)api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let authorizationValue = "Basic \((clientId + ":" + secretKey).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": authorizationValue,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        var requestBodyComponents = URLComponents()
        let scopeAsString = stringScopes.joined(separator: " ") 
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: authCode),
            URLQueryItem(name: "redirect_uri", value: redirect),
            URLQueryItem(name: "code_verifier", value: ""),
            URLQueryItem(name: "scope", value: scopeAsString),
        ]
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                return completion("no data found")
            }
            
            do {
                if let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                    guard let accessToken = jsonResult["access_token"] as? String else { return }
                    self.accessToken = accessToken
                    self.refreshToken = jsonResult["refresh_token"] as? String
                    Spartan.authorizationToken = accessToken
                    return completion(nil)
                }
                return completion("failed decode")
            }
        }
        task.resume()
    }
    
    
    static func refreshAccessToken(completion: @escaping (_ error: String?) -> Void) {
        guard let refreshToken = refreshToken else {
            return completion("No refresh token")
        }
        let url = URL(string: "\(baseURL)api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((clientId + ":" + secretKey).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: clientId),
        ]
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200 ..< 300) ~= response.statusCode,
                  error == nil else {
                return completion("No data found")
            }
            do {
                
                if let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                    // update refresh token
                    self.refreshToken = jsonResult["access_token"] as? String
                    Spartan.authorizationToken = jsonResult["access_token"] as? String
                    return completion(nil)
                }
                return completion("Failed to decode data")
            }
        }
        task.resume()
    }
    
    //    static func fetchRefreshToken() {
    //        var baseURL = "https://accounts.spotify.com/api/token"
    //    }
    
    
}
