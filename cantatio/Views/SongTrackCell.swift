//
//  SongTrackCell.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/30/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Spartan

class SongTrackCell: UITableViewCell {
    
    var linkVC: FavSongsVC?
    var songURL = ""
    var audioPlayer = AudioController.shared
    let userDefaults = UserDefaults.standard
    var favoritedSongs = [String]()
    var songs = [Track]()
    var artistID = ""
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        return stackView
    }()
    
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
        button.addTarget(self, action: #selector(favTapped), for: .touchDown)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        UserDefaults.standard
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        contentView.addSubview(title)
        contentView.addSubview(albumImage)
        contentView.addSubview(stackView)
        setUpImage()
        setUpTitle()
        setupButtons()
    }
    
    func setUpTitle() {
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -12).isActive = true
        title.leadingAnchor.constraint(equalTo: albumImage.trailingAnchor, constant: 10).isActive = true
        title.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setUpImage() {
        albumImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        albumImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        albumImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        albumImage.widthAnchor.constraint(equalTo: albumImage.heightAnchor, multiplier: 16/15).isActive = true
    }
    
    func setupButtons() {
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackView.widthAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 16/15).isActive = true
        
        stackView.addArrangedSubview(favoriteButton)
        favoriteButton.addTarget(self, action: #selector(favTapped), for: .touchDown)
        
        stackView.addArrangedSubview(playButton)
        playButton.addTarget(self, action: #selector(playPauseTapped), for: .touchDown)
    }

    
    @objc func favTapped(){
        if self.favoriteButton.currentImage == UIImage(named: "icon_favorite"){
            
            UIView.animate(withDuration: 0.3,
            animations: {
                self.favoriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.favoriteButton.transform = CGAffineTransform.identity
                }
            })
            self.favoriteButton.setImage(UIImage(named: "icon_favorite-filled"), for: .normal)
            
            // save song in user defaults if favorited
            favoritedSongs.append(artistID)
            UserDefaults.standard.set(self.favoritedSongs, forKey: "favorited")
            
        } else {
            self.favoriteButton.setImage(UIImage(named: "icon_favorite"), for: .normal)
            
            // remove song from user defaults
            UserDefaults.standard.removeObject(forKey: "favorited")
        }
    }
    
    
    @objc func playPauseTapped(){
        if self.playButton.currentImage == UIImage(named: "icon_play"){
            
            // animate play button
            UIView.animate(withDuration: 0.3,
            animations: {
                self.playButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.3) {
                    self.playButton.transform = CGAffineTransform.identity
                }
            })
            self.playButton.setImage(UIImage(named: "icon_pause"), for: .normal)
            
            // play song from url when pay button is clicked
            audioPlayer.downloadFileFromURL(url: URL(string: songURL)!)
            
        } else {
            // if button is pressed again, pause song and change image to pause
            self.playButton.setImage(UIImage(named: "icon_play"), for: .normal)
            audioPlayer.pause()
        }
    }
    
    
}

