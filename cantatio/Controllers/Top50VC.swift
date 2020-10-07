//
//  Top50VC.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import Spartan
import AVFoundation


class Top50VC: UIViewController {
    
    typealias JSONStandard = [String : AnyObject]
    var player = AVAudioPlayer()
    var artists: [Artist] = []
    var network = NetworkManager()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(Top50Cell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.navigationItem.title = "Top 50 Artists"
        navigationController?.navigationBar.prefersLargeTitles = true
        fetchArtists()
        print(artists)
    }
    
    func setUpTableView(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func fetchArtists() {
        
//        NetworkManager.fetchNewReleases()
        
        NetworkManager.getUser()
        
//        NetworkManager.fetchTopArtists() { (result) in
//
//            switch result{
//            case .failure(let error):
//                print(error)
//            case .success(let artists):
//                self.artists = artists
//                self.tableView.reloadData()
//            }
//        }
    }
    
    
}

extension Top50VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return 10
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Top50Cell
        cell.accessoryType = .disclosureIndicator
        cell.title.text = artists[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected item in row \(indexPath.row)")
        let nextView: ArtistInfoVC = ArtistInfoVC()
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
}
