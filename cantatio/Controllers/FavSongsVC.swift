//
//  FavoriteSongsVC.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit

class FavSongsVC: UIViewController {
    
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
    
}

extension FavSongsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SongTrackCell
        cell.selectionStyle = .none
        return cell
    }
}
