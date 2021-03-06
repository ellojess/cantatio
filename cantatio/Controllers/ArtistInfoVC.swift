//
//  ArtistInfoVC.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import Spartan
import Kingfisher
import AVFoundation

class ArtistInfoVC: UIViewController {
    
//    var artistID = ""
    var songs:[Track] = []
    var favoritedSongs = [String]()
    lazy var artistID = self.artist.id as! String
    var artist: Artist! = nil
    var audioPlayer = AVAudioPlayer()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 100
        return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        fetchTracks()
      
        self.navigationItem.title = "Top Tracks"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    // MARK: Fetch top tracks from Artist
    func fetchTracks() {

        NetworkManager.fetchArtistTopTracks(artistId: artistID) { (result) in

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

extension ArtistInfoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongTrackCell
        cell.selectionStyle = .none
        let song = songs[indexPath.row]
        let urlString = song.album.images.first?.url
//        print("HELLOOOOO URL STRING \(urlString)")
        let url = URL(string: urlString!)
        cell.albumImage.kf.setImage(with: url)
        cell.title.text = songs[indexPath.row].name
        cell.songID = songs[indexPath.row].id as! String
        
        guard let songURL = songs[indexPath.row].previewUrl else{
              cell.playButton.isEnabled = false
              return cell
            }
        cell.songURL = songURL
        cell.playButton.isEnabled = true
        
        // get favorited tracks from user defaults from each cell
        // .contains() to see if it exists
        //  if song is in songID then change image to filled-heart
        
        guard let songID = self.songs[indexPath.row].id else {
            return cell
        }
        
        if self.favoritedSongs.contains(songID as! String) {
            cell.favoriteButton.setImage(UIImage(named: "icon_favorite"), for: .normal)
        }
        
        UserDefaults.standard.setValue(self.favoritedSongs, forKey: "favorited")
        
        return cell
    }
}
