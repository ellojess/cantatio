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
import Kingfisher


class Top50VC: UIViewController {
    
    typealias JSONStandard = [String : AnyObject]
    
    var artists: [Artist] = []
    
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
        NetworkManager.fetchTopArtists() { (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let artists):
                self.artists = artists
                self.tableView.reloadData()
            }
        }
    }
    

    
}

extension Top50VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Top50Cell
        cell.accessoryType = .disclosureIndicator
        
        let nextView: ArtistInfoVC = ArtistInfoVC()
        nextView.artistID = artists[indexPath.row].id as! String
        
        let urlString = artists[indexPath.row].images.first?.url
        let url = URL(string: urlString!)
        cell.imageView?.kf.setImage(with: url, options: []) { result in
            
            switch result{
            case .success(let value):
                
                DispatchQueue.main.async{
                    cell.imageView?.image = value.image
                    cell.textLabel?.text = self.artists[indexPath.row].name
                }
                
            case .failure(let error):
                print(error)
            }
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected item in row \(indexPath.row)")
        let nextView: ArtistInfoVC = ArtistInfoVC()
        nextView.artistID = artists[indexPath.row].id as! String
        print(artists[indexPath.row].id)
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
}
