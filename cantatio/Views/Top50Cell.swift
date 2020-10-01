//
//  Top50Cell.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/30/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit

class Top50Cell: UITableViewCell {
    
    var albumImage: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 0
        title.adjustsFontSizeToFitWidth = true
        title.textColor = .black
        return title
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
        
        NSLayoutConstraint.activate([
            albumImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            albumImage.widthAnchor.constraint(equalToConstant: 20),
            albumImage.heightAnchor.constraint(equalToConstant: 20),
            albumImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            title.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10),
            title.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            
        ])
   
    }
    
}

