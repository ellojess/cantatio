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
    
    typealias JSONStandard = [String : AnyObject]
    var posts = [Track]()
    
    public static var authorizationToken: String?
    public static var loggingEnabled: Bool = true
    
    static var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: NetworkManager.kAccessTokenKey)
        }
    }
    
    static var refreshToken = UserDefaults.standard.string(forKey: kRefreshTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: NetworkManager.kRefreshTokenKey)
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
    
    // Fetch Artist's Top Tracks
    static func fetchTopTracks(artistId: String, completion: @escaping (Result<[Artist], Error>) -> Void) {
        _ = Spartan.getArtistsTopTracks(artistId: artistId, country: .us, success: { (tracks) in
           // Do something with the tracks
       }, failure: { (error) in
           print(error)
       })
    }
    
    
    
//    func parseData(JSONData : Data) {
//        do {
//            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
//            if let tracks = readableJSON["tracks"] as? JSONStandard{
//                if let items = tracks["items"] as? [JSONStandard] {
//                    for i in 0..<items.count{
//                        let item = items[i]
//                        print(item)
//                        let name = item["name"] as! String
//                        let previewURL = item["preview_url"] as! String
//                        if let album = item["album"] as? JSONStandard{
//                            if let images = album["images"] as? [JSONStandard]{
//                                let imageData = images[0]
//                                let mainImageURL =  URL(string: imageData["url"] as! String)
//                                let mainImageData = NSData(contentsOf: mainImageURL!)
//
//                                let mainImage = UIImage(data: mainImageData! as Data)
//
//                                posts.append(Track.init(mainImage: mainImage, name: name, previewURL: previewURL))
////                                self.tableView.reloadData()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        catch{
//            print(error)
//        }
//    }
    
    
    
}
