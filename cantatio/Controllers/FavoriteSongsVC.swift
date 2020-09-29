//
//  FavoriteSongsVC.swift
//  cantatio
//
//  Created by Jessica Trinh on 9/12/20.
//  Copyright © 2020 Jessica Trinh. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import AVFoundation
import CoreData

class FavoriteSongsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .green
    }
    
}


struct FavoriteTracks: Identifiable {
    var id: Int
    var songtitle: String
    var coverphoto: String
    var artist: String
    
}

struct FavSongView: View {
    
    let songs: [FavoriteTracks] = [
        // mock data
        .init(id: 0, songtitle: "Do", coverphoto: "icon_profile", artist: "Bob"),
        .init(id: 1, songtitle: "re", coverphoto: "icon_profile", artist: "Tim"),
        .init(id: 2, songtitle: "me", coverphoto: "icon_profile", artist: "Kevin")
    ]
    
    var body: some View {
        NavigationView{
            List{
                ForEach(songs){ song in
                    // artist row
                    FavSongRow(song: song)
                }
                // TODO: replave "Artist" with actual artist name
                }.navigationBarTitle(Text("Your Favorite Songs"))
        }
    }
}

struct FavSongRow: View {
    let song: FavoriteTracks
    
    var body: some View {
        HStack{
            // mock data of artist image
            Image("icon_profile")
                .resizable()
                .frame(width: 70, height: 70)
                .clipped()
            VStack{
                Text(song.songtitle).font(.headline)
                Text(song.artist).font(.subheadline)
            }
            
            Spacer()
            Button(action: {
                print("play button pressed")
            }) {
                Image("icon_play")
            }
//                    .padding(.trailing, 10)
//            }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
        }.buttonStyle(PlainButtonStyle())
    }
}

struct FavSongView_Previews: PreviewProvider {
    static var previews: some View {
        FavSongView()
    }
}





