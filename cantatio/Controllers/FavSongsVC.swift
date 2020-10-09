//
//  FavoriteSongsVC.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import Spartan

class FavSongsVC: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    var favoritedSongs: [String] = UserDefaults.standard.stringArray(forKey: "favorited") ?? [String]()
    
    var songs = [Track]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 100
        return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
      
        self.navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchSongs()
    }
    
    func setUpTableView(){
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.register(SongTrackCell.self, forCellReuseIdentifier: "cell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchSongs() {
        NetworkManager.fetchSong(trackIds: favoritedSongs) { (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let songs):
                self.songs = songs
                self.tableView.reloadData()
            }
        }
    }
    
    
}

extension FavSongsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 5
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongTrackCell
        cell.selectionStyle = .none
        cell.favoriteButton.isHidden = true
        
        let urlString = songs[indexPath.row].album.images.first?.url
//        print("HELLOOOOO URL STRING \(urlString)")
        let url = URL(string: urlString!)
        cell.albumImage.kf.setImage(with: url)
        cell.title.text = songs[indexPath.row].name
        
        
        guard let songURL = songs[indexPath.row].previewUrl else{
              cell.playButton.isEnabled = false
              return cell
            }
        cell.songURL = songURL
        cell.playButton.isEnabled = true
        
//        return cell
        
    
        cell.imageView?.kf.setImage(with: url, options: [], completionHandler:  { result in
            
            switch result{
            case .success(let value):
                
                DispatchQueue.main.async{
                    cell.imageView?.image = value.image
                    cell.textLabel?.text = self.songs[indexPath.row].name
                }
                
            case .failure(let error):
                print(error)
            }
        })
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .none {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            print("testing editing style")
        }
    }
    
}
