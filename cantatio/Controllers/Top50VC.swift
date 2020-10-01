//
//  Top50VC.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit

class Top50VC: UIViewController {
    
    typealias JSONStandard = [String : AnyObject]
    var posts = [Track]()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 100
        return tableView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(Top50Cell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .orange
        setUpTableView()
        
        self.navigationItem.title = "Top 50 Artists"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setUpTableView(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func parseData(JSONData : Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            if let tracks = readableJSON["tracks"] as? JSONStandard{
                if let items = tracks["items"] as? [JSONStandard] {
                    for i in 0..<items.count{
                        let item = items[i]
                        print(item)
                        let name = item["name"] as! String
                        let previewURL = item["preview_url"] as! String
                        if let album = item["album"] as? JSONStandard{
                            if let images = album["images"] as? [JSONStandard]{
                                let imageData = images[0]
                                let mainImageURL =  URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageURL!)
                                
                                let mainImage = UIImage(data: mainImageData! as Data)
                                
                                posts.append(Track.init(mainImage: mainImage, name: name, previewURL: previewURL))
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        catch{
            print(error)
        }
    }

    
}

extension Top50VC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return posts.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Top50Cell
        cell.accessoryType = .disclosureIndicator
        
//        let mainImageView = cell.albumImage as! UIImageView
//        cell.albumImage.image = posts[indexPath.row].mainImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected item in row \(indexPath.row)")
        let nextView: ArtistInfoVC = ArtistInfoVC()
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
}
