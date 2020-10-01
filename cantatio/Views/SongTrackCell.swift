//
//  SongTrackCell.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/30/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit

class SongTrackCell: UITableViewCell {
    
    var albumImage: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true
        title.textColor = .black
        return title
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_play"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_pause"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_favorite"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(albumImage)
        contentView.addSubview(title)
        contentView.addSubview(playButton)
        contentView.addSubview(favoriteButton)
        
        NSLayoutConstraint.activate([
            albumImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            albumImage.widthAnchor.constraint(equalToConstant: 20),
            albumImage.heightAnchor.constraint(equalToConstant: 20),
            albumImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            title.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10),
            title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            
            playButton.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            
            favoriteButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 10),
            favoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0)
        ])
   
    }
    
    
    
    
    
}

